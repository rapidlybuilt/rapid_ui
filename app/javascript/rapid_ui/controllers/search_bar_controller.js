import { Controller } from "@hotwired/stimulus"
import { makeXHRRequest, isSmall } from "helpers"
import { SearchHelper } from "helpers/search_helper"

export default class extends Controller {
  static targets = [
    "desktopInput", "mobileInput", "desktopClearButton", "mobileClearButton",
    "dropdown", "results", "staticResults", "dynamicResults", "loading", "error", "shortcutHint",
    "emptyResults", "resultTemplate",
  ]
  static classes = ["hidden", "highlighted", "loading"]
  static values = {
    dynamicPath: String,
    staticPath: String
  }

  connect() {
    // setup search functionality
    this.searchTimeout = null;
    this.isSearching = false;
    this.selectedIndex = -1;
    this.hasStaticResults = false;

    // Initialize search helper
    this.searchHelper = new SearchHelper({
      staticPath: this.staticPathValue,
      resultTemplate: this.resultTemplateTarget
    });

    // Add document click listener to hide search dropdown
    this.boundDocumentClick = this.onDocumentClick.bind(this);
    document.addEventListener('click', this.boundDocumentClick);

    // Add keyboard event listeners
    this.boundKeydown = this.onKeydown.bind(this);
    document.addEventListener('keydown', this.boundKeydown);

    // Initialize shortcut visibility based on current input content
    this.toggleShortcutHintVisibility(this.inputTarget.value.trim().length > 0);
  }

  // Handle focus on search input - lazy load static index
  onFocus(event) {
    this.searchHelper.fetchStaticIndex();
  }

  // Show "No results found" message
  showNoResults() {
    this.emptyResultsTarget.classList.remove(this.hiddenClassWithDefault);
  }

  // Hide "No results found" message
  hideNoResults() {
    this.emptyResultsTarget.classList.add(this.hiddenClassWithDefault);
  }

  get inputTarget() {
    return isSmall() ? this.mobileInputTarget : this.desktopInputTarget;
  }

  get clearButtonTarget() {
    return isSmall() ? this.mobileClearButtonTarget : this.desktopClearButtonTarget;
  }

  get hiddenClassWithDefault() {
    return this.hasHiddenClass ? this.hiddenClass : "hidden";
  }

  get highlightedClassWithDefault() {
    return this.hasHighlightedClass ? this.highlightedClass : "search-bar-result-highlighted";
  }

  get loadingClassWithDefault() {
    return this.hasLoadingClass ? this.loadingClass : "search-bar-loading-results";
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
      if (isSmall()) {
        this.clearResults();
      } else {
        this.hideDropdown();
        this.selectedIndex = -1;
      }
      return;
    }

    // Reset selected index for new search
    this.selectedIndex = -1;

    // Immediately search static index (instant results)
    this.performStaticSearch(query);

    // Debounce dynamic search requests
    if (this.hasDynamicPathValue && this.dynamicPathValue) {
      this.searchTimeout = setTimeout(() => {
        this.performDynamicSearch(query);
      }, 300);
    }
  }

  // Perform instant search on static index
  performStaticSearch(query) {
    const staticResults = this.searchHelper.searchStaticIndex(query);
    const staticFragment = this.searchHelper.renderResults(staticResults);

    this.showDropdown();

    // Track if we have static results
    this.hasStaticResults = staticResults.length > 0;

    // Hide "no results" message first
    this.hideNoResults();

    // Update static results section
    if (this.hasStaticResultsTarget) {
      this.staticResultsTarget.innerHTML = '';
      this.staticResultsTarget.appendChild(staticFragment);
    } else {
      // Fallback: use main results target if no separate static target
      this.resultsTarget.innerHTML = '';

      if (staticResults.length === 0 && !this.shouldFetchDynamicResults()) {
        // Show "No results" if no static results AND dynamic search is disabled
        this.showNoResults();
      } else {
        this.resultsTarget.appendChild(staticFragment);
      }
    }

    this.resultsTarget.classList.remove(this.hiddenClassWithDefault);
    this.toggleClearButtonVisibility(staticResults.length > 0 || this.shouldFetchDynamicResults());

    // Highlight first result if we have any
    if (staticResults.length > 0) {
      this.highlightFirstResult();
    }
  }

  // Check if we should fetch dynamic results
  shouldFetchDynamicResults() {
    return this.hasDynamicPathValue && this.dynamicPathValue;
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

  // Perform dynamic search (server-side, debounced)
  async performDynamicSearch(query) {
    this.showLoadingIndicator();

    try {
      this.isSearching = true;

      // Make HTTP request to dynamic search endpoint
      const responseText = await makeXHRRequest(this.dynamicPathValue, { params: { q: query } });
      const dynamicResults = JSON.parse(responseText);
      this.isSearching = false;

      this.hideLoadingIndicator();

      const hasDynamicResults = dynamicResults.length > 0;

      // Render dynamic results using template (same as static)
      const dynamicFragment = this.searchHelper.renderResults(dynamicResults);

      // Append dynamic results after static results
      if (this.hasDynamicResultsTarget) {
        this.dynamicResultsTarget.innerHTML = '';
        this.dynamicResultsTarget.appendChild(dynamicFragment);
      } else {
        // Fallback: append to main results if no separate dynamic target
        if (hasDynamicResults) {
          this.resultsTarget.appendChild(dynamicFragment);
        } else if (!this.hasStaticResults) {
          // No static results and no dynamic results - show "No results"
          this.showNoResults();
        }
      }

      this.resultsTarget.classList.remove(this.hiddenClassWithDefault);
      this.toggleClearButtonVisibility(true);

      // Highlight first result (selectedIndex was reset in onInput)
      if (this.selectedIndex < 0 && this.getResultItems().length > 0) {
        this.highlightFirstResult();
      }
    } catch (error) {
      console.error(error);
      this.hideLoadingIndicator();

      // Don't show error state if we have static results
      if (this.getResultItems().length === 0) {
        this.displaySearchError();
      }
    }
  }

  // Legacy method for backward compatibility
  async performSearch(query) {
    // If we have static search, use the new flow
    if (this.hasStaticPathValue && this.staticPathValue) {
      this.performStaticSearch(query);
      if (this.hasDynamicPathValue && this.dynamicPathValue) {
        await this.performDynamicSearch(query);
      }
    } else {
      // Original behavior for backward compatibility
      this.showDropdown();
      this.showLoadingIndicator();

      try {
        this.isSearching = true;
        const html = await makeXHRRequest(this.dynamicPathValue, { params: { q: query } });
        this.isSearching = false;

        this.hideAllStates();
        this.resultsTarget.innerHTML = html;
        this.resultsTarget.classList.remove(this.hiddenClassWithDefault);
        this.toggleClearButtonVisibility(true);
        this.highlightFirstResult();
      } catch (error) {
        console.error(error);
        this.displaySearchError();
      }
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
    isSmall() && this.mobileInputTarget.focus();
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
    // Always show loading indicator (appears below results)
    this.loadingTarget.classList.remove(this.hiddenClassWithDefault);

    // Only add loading class if no results yet (for backwards compatibility)
    if (!this.resultsTarget.innerHTML.trim()) {
      this.resultsTarget.classList.add(this.loadingClassWithDefault);
    }
  }

  displaySearchError() {
    this.hideAllStates();
    this.errorTarget.classList.remove(this.hiddenClassWithDefault);
  }

  hideLoadingIndicator() {
    this.loadingTarget.classList.add(this.hiddenClassWithDefault);
    this.resultsTarget.classList.remove(this.loadingClassWithDefault);
  }

  hideAllStates() {
    this.loadingTarget.classList.add(this.hiddenClassWithDefault);
    this.errorTarget.classList.add(this.hiddenClassWithDefault);
    this.hideNoResults();
    this.resultsTarget.classList.remove(this.loadingClassWithDefault);
    this.resultsTarget.innerHTML = "";
    if (this.hasStaticResultsTarget) {
      this.staticResultsTarget.innerHTML = "";
    }
    if (this.hasDynamicResultsTarget) {
      this.dynamicResultsTarget.innerHTML = "";
    }
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
    this.hideNoResults();
    if (this.hasStaticResultsTarget) {
      this.staticResultsTarget.innerHTML = "";
    }
    if (this.hasDynamicResultsTarget) {
      this.dynamicResultsTarget.innerHTML = "";
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
    return this.resultsTarget.querySelectorAll('.search-bar-result-item');
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
