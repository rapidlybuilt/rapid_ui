import { Controller } from "@hotwired/stimulus"
import { makeXHRRequest } from "helpers"

export default class extends Controller {
  static targets = ["input", "dropdown", "results", "loading", "error", "noResults", "shortcut"]
  static classes = ["hidden", "highlighted"]
  static values = { path: String }

  connect() {
    // setup search functionality
    this.searchTimeout = null;
    this.isSearching = false;
    this.selectedIndex = -1;

    // Add document click listener to hide search dropdown
    this.boundDocumentClick = this.onDocumentClick.bind(this);
    document.addEventListener('click', this.boundDocumentClick);

    // Add keyboard event listeners
    this.boundKeydown = this.onKeydown.bind(this);
    document.addEventListener('keydown', this.boundKeydown);

    // Initialize shortcut visibility based on current input content
    this.toggleShortcutVisibility(this.inputTarget.value.trim().length > 0);
  }

  get hiddenClassWithDefault() {
    return this.hasHiddenClass ? this.hiddenClass : "hidden";
  }

  get highlightedClassWithDefault() {
    return this.hasHighlightedClass ? this.highlightedClass : "search-result-highlighted";
  }

  disconnect() {
    // Clean up document click listener
    if (this.boundDocumentClick) {
      document.removeEventListener('click', this.boundDocumentClick);
    }

    // Clean up keyboard event listener
    if (this.boundKeydown) {
      document.removeEventListener('keydown', this.boundKeydown);
    }

    // Clear search timeout
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout);
    }
  }

  onInput(event) {
    const query = event.target.value.trim();

    // Toggle shortcut visibility based on input content
    this.toggleShortcutVisibility(query.length > 0);

    // Clear previous timeout
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout);
    }

    if (query.length === 0) {
      this.hideDropdown();
      this.selectedIndex = -1;
      return;
    }

    // Debounce search requests
    this.searchTimeout = setTimeout(() => {
      this.performSearch(query);
    }, 300);
  }

  onKeydown(event) {
    // Handle global shortcuts (Option+S / Alt+S to focus search)
    // Check for both lowercase and uppercase, and also check for keyCode as fallback
    if ((event.altKey || event.metaKey) && (event.key === 's' || event.key === 'S' || event.keyCode === 83)) {
      event.preventDefault();
      this.focusSearch();
      return;
    }

    // Only handle other shortcuts if search input is focused or dropdown is visible
    if (!this.isSearchFocused() && !this.isDropdownVisible()) {
      return;
    }

    switch (event.key) {
      case 'Escape':
        this.handleEscape();
        break;
      case 'ArrowUp':
        event.preventDefault();
        this.navigateResults(-1);
        break;
      case 'ArrowDown':
        event.preventDefault();
        this.navigateResults(1);
        break;
      case 'Enter':
        event.preventDefault();
        this.selectResult();
        break;
    }
  }

  async performSearch(query) {
    this.showDropdown();
    this.showLoadingIndicator();

    try {
      this.isSearching = true;

      // Make real HTTP request to search endpoint using XMLHttpRequest
      const html = await makeXHRRequest(this.pathValue, { params: { q: query } });
      this.isSearching = false;

      this.hideAllStates();
      this.resultsTarget.innerHTML = html;
      this.resultsTarget.classList.remove(this.hiddenClassWithDefault);

      // Highlight the first result by default
      this.highlightFirstResult();
    } catch (error) {
      this.displaySearchError();
    }
  }


  showDropdown() {
    this.dropdownTarget.classList.remove(this.hiddenClassWithDefault);
  }

  hideDropdown() {
    this.dropdownTarget.classList.add(this.hiddenClassWithDefault);
  }

  showLoadingIndicator() {
    this.hideAllStates();
    this.loadingTarget.classList.remove(this.hiddenClassWithDefault);
  }


  displaySearchError() {
    this.hideAllStates();
    this.errorTarget.classList.remove(this.hiddenClassWithDefault);
  }

  hideAllStates() {
    this.loadingTarget.classList.add(this.hiddenClassWithDefault);
    this.errorTarget.classList.add(this.hiddenClassWithDefault);
    this.noResultsTarget.classList.add(this.hiddenClassWithDefault);
    this.resultsTarget.innerHTML = "";
    this.selectedIndex = -1;
  }

  // Hide search dropdown when clicking outside
  onDocumentClick(event) {
    if (!this.element.contains(event.target)) {
      this.hideDropdown();
    }
  }

  // Keyboard shortcut helper methods
  focusSearch() {
    this.inputTarget.focus();
  }

  isSearchFocused() {
    return document.activeElement === this.inputTarget;
  }

  isDropdownVisible() {
    return !this.dropdownTarget.classList.contains(this.hiddenClassWithDefault);
  }

  handleEscape() {
    if (this.isSearchFocused()) {
      this.hideDropdown();
      this.inputTarget.value = "";
      this.selectedIndex = -1;
      this.toggleShortcutVisibility(false);
    }
  }

  navigateResults(direction) {
    if (!this.isDropdownVisible()) return;

    const resultItems = this.getResultItems();
    if (resultItems.length === 0) return;

    // Remove previous highlight
    this.clearHighlight();

    // Update selected index
    this.selectedIndex += direction;

    // Wrap around
    if (this.selectedIndex < 0) {
      this.selectedIndex = resultItems.length - 1;
    } else if (this.selectedIndex >= resultItems.length) {
      this.selectedIndex = 0;
    }

    // Add highlight to new selection
    this.highlightResult(this.selectedIndex);
  }

  selectResult() {
    if (this.selectedIndex >= 0) {
      const resultItems = this.getResultItems();
      if (resultItems[this.selectedIndex]) {
        // Simulate click on the result item
        resultItems[this.selectedIndex].click();
      }
    }
  }

  getResultItems() {
    return this.resultsTarget.querySelectorAll('.search-result-item');
  }

  clearHighlight() {
    const resultItems = this.getResultItems();
    resultItems.forEach(item => {
      item.classList.remove(this.highlightedClassWithDefault);
    });
  }

  highlightResult(index) {
    const resultItems = this.getResultItems();
    if (resultItems[index]) {
      resultItems[index].classList.add(this.highlightedClassWithDefault);

      // Scroll the selected item into view
      resultItems[index].scrollIntoView({
        behavior: 'smooth',
        block: 'nearest'
      });
    }
  }

  highlightFirstResult() {
    const resultItems = this.getResultItems();
    if (resultItems.length > 0) {
      this.selectedIndex = 0;
      this.highlightResult(0);
    }
  }

  toggleShortcutVisibility(hasText) {
    if (hasText) {
      this.shortcutTarget.classList.add(this.hiddenClassWithDefault);
    } else {
      this.shortcutTarget.classList.remove(this.hiddenClassWithDefault);
    }
  }
}
