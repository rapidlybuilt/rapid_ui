import { Controller } from "@hotwired/stimulus"
import { makeXHRRequest } from "helpers"

function isMobile() {
  return window.innerWidth < 768;
}

export default class extends Controller {
  static targets = [
    "desktopInput", "mobileInput", "desktopClearButton", "mobileClearButton",
    "dropdown", "results", "loading", "error", "shortcutHint",
  ]
  static classes = ["hidden", "highlighted", "loading"]
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
    this.toggleShortcutHintVisibility(this.inputTarget.value.trim().length > 0);
  }

  get inputTarget() {
    return isMobile() ? this.mobileInputTarget : this.desktopInputTarget;
  }

  get clearButtonTarget() {
    return isMobile() ? this.mobileClearButtonTarget : this.desktopClearButtonTarget;
  }

  get hiddenClassWithDefault() {
    return this.hasHiddenClass ? this.hiddenClass : "hidden";
  }

  get highlightedClassWithDefault() {
    return this.hasHighlightedClass ? this.highlightedClass : "search-result-highlighted";
  }

  get loadingClassWithDefault() {
    return this.hasLoadingClass ? this.loadingClass : "search-loading-results";
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
    this.toggleShortcutHintVisibility(query.length > 0);

    // Clear previous timeout
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout);
    }

    if (query.length === 0) {
      if (isMobile()) {
        this.clearResults();
      } else {
        this.hideDropdown();
        this.selectedIndex = -1;
      }
      return;
    }

    // Debounce search requests
    this.searchTimeout = setTimeout(() => {
      this.performSearch(query);
    }, 300);
  }

  // TODO: which of these could be driven by `keydown.XXX->XXX#method`?
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

      // Show close button when results are present
      this.toggleClearButtonVisibility(true);

      // Highlight the first result by default
      this.highlightFirstResult();
    } catch (error) {
      console.error(error);
      this.displaySearchError();
    }
  }

  toggleDropdown() {
    if (this.isDropdownVisible()) {
      this.hideDropdown();
    } else {
      this.showDropdown();
    }
  }

  showDropdown() {
    this.dropdownTarget.classList.remove(this.hiddenClassWithDefault);
    isMobile() && this.mobileInputTarget.focus();
  }

  hideDropdown() {
    this.dropdownTarget.classList.add(this.hiddenClassWithDefault);
    this.hideClearButton();
  }

  closeDropdown() {
    this.hideDropdown();
    this.inputTarget.value = "";
    this.selectedIndex = -1;
    this.toggleClearButtonVisibility(false);
    this.toggleShortcutHintVisibility(false);
  }

  showClearButton() {
    this.clearButtonTarget.classList.remove(this.hiddenClassWithDefault);
  }

  hideClearButton() {
    this.clearButtonTarget.classList.add(this.hiddenClassWithDefault);
  }

  showLoadingIndicator() {
    if (!this.resultsTarget.innerHTML.trim()) {
      this.hideAllStates();
      this.loadingTarget.classList.remove(this.hiddenClassWithDefault);
    }

    this.resultsTarget.classList.add(this.loadingClassWithDefault);
  }

  displaySearchError() {
    this.hideAllStates();
    this.errorTarget.classList.remove(this.hiddenClassWithDefault);
  }

  hideAllStates() {
    this.loadingTarget.classList.add(this.hiddenClassWithDefault);
    this.errorTarget.classList.add(this.hiddenClassWithDefault);
    this.resultsTarget.classList.remove(this.loadingClassWithDefault);
    this.resultsTarget.innerHTML = "";
    this.selectedIndex = -1;
    this.toggleClearButtonVisibility(false);
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

  clearSearch() {
    this.inputTarget.value = "";
    this.focusSearch();
    this.clearResults();
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
      this.toggleClearButtonVisibility(false);
      this.toggleShortcutHintVisibility(false);
    }
  }

  clearResults() {
    this.resultsTarget.innerHTML = "";
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

  toggleShortcutHintVisibility(hasText) {
    if (hasText) {
      this.shortcutHintTarget.classList.add(this.hiddenClassWithDefault);
    } else {
      this.shortcutHintTarget.classList.remove(this.hiddenClassWithDefault);
    }
  }

  toggleClearButtonVisibility(hasResults) {
    if (hasResults) {
      this.clearButtonTarget.classList.remove(this.hiddenClassWithDefault);
      this.shortcutHintTarget.classList.add(this.hiddenClassWithDefault);
    } else {
      this.clearButtonTarget.classList.add(this.hiddenClassWithDefault);
    }
  }
}
