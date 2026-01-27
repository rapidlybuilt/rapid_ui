import { Controller } from "@hotwired/stimulus"
import { SearchHelper } from "helpers/search_helper"
import { makeXHRRequest } from "helpers"

export default class extends Controller {
  static targets = ["results", "emptyResults", "loading", "resultTemplate", "input", "query", "queryContainer"]
  static classes = ["hidden"]
  static values = {
    dynamicPath: String,
    staticPath: String,
    queryParam: { type: String, default: "q" }
  }

  async connect() {
    // Initialize search helper
    this.searchHelper = new SearchHelper({
      staticPath: this.staticPathValue,
      resultTemplate: this.resultTemplateTarget
    });

    // Track search state
    this.hasStaticResults = false;
    this.searchTimeout = null;

    await this.searchHelper.fetchStaticIndex();

    // Read query from URL parameter
    const query = this.getQueryFromUrl();

    if (query) {
      // Populate input field
      if (this.hasInputTarget) {
        this.inputTarget.value = query;
      }
      if (this.hasQueryTarget) {
        this.queryTarget.textContent = query;
      }

      // Perform initial search
      this.performSearch(query);
    } else {
      this.hideQueryContainer();
    }
  }

  // Get query parameter from URL
  getQueryFromUrl() {
    const params = new URLSearchParams(window.location.search);
    return params.get(this.queryParamValue) || "";
  }

  // Handle input changes
  onInput(event) {
    const query = event.target.value.trim();

    if (query.length === 0) {
      this.clearResults();
      return;
    }

    // Debounce search
    clearTimeout(this.searchTimeout);
    this.searchTimeout = setTimeout(() => {
      this.performSearch(query);
    }, 300);
  }

  // Perform search (static + dynamic)
  performSearch(query) {
    // Clear previous results
    this.clearResults();

    // Perform static search immediately
    this.performStaticSearch(query);

    // Perform dynamic search if configured
    if (this.hasDynamicPathValue && this.dynamicPathValue) {
      this.performDynamicSearch(query);
    }
  }

  // Perform static search
  performStaticSearch(query) {
    const results = this.searchHelper.searchStaticIndex(query);
    this.hasStaticResults = results.length > 0;
    this.renderStaticResults(results);
  }

  // Perform dynamic search (server-side)
  async performDynamicSearch(query) {
    this.showLoading();

    try {
      const responseText = await makeXHRRequest(this.dynamicPathValue, {
        method: 'GET',
        params: { q: query }
      });
      const dynamicResults = JSON.parse(responseText);

      this.hideLoading();
      this.renderDynamicResults(dynamicResults);
    } catch (error) {
      console.error("Dynamic search failed:", error);
      this.hideLoading();
    }
  }

  // Render static search results
  renderStaticResults(results) {
    this.resultsTarget.innerHTML = '';
    this.hideEmptyResults();

    if (results.length > 0) {
      const fragment = this.searchHelper.renderResults(results);
      this.resultsTarget.appendChild(fragment);
      this.showQueryContainer();
    }
  }

  // Render dynamic search results (append after static)
  renderDynamicResults(results) {
    if (results.length > 0) {
      const fragment = this.searchHelper.renderResults(results);
      this.resultsTarget.appendChild(fragment);
      this.showQueryContainer();
    } else if (!this.hasStaticResults) {
      // No static results and no dynamic results - show "No results"
      this.showEmptyResults();
    }
  }

  // Show loading indicator
  showLoading() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.remove(this.hiddenClassWithDefault);
    }
  }

  // Hide loading indicator
  hideLoading() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.add(this.hiddenClassWithDefault);
    }
  }

  // Show "No results found" message
  showEmptyResults() {
    if (this.hasEmptyResultsTarget) {
      this.emptyResultsTarget.classList.remove(this.hiddenClassWithDefault);
    }
  }

  // Hide "No results found" message
  hideEmptyResults() {
    if (this.hasEmptyResultsTarget) {
      this.emptyResultsTarget.classList.add(this.hiddenClassWithDefault);
    }
  }

  hideQueryContainer() {
    if (this.hasQueryContainerTarget) {
      this.queryContainerTarget.classList.add(this.hiddenClassWithDefault);
    }
  }

  showQueryContainer() {
    if (this.hasQueryContainerTarget) {
      this.queryContainerTarget.classList.remove(this.hiddenClassWithDefault);
    }
  }

  // Clear results
  clearResults() {
    this.resultsTarget.innerHTML = '';
    this.hideEmptyResults();
    this.hideLoading();
    this.hideQueryContainer();
    this.hasStaticResults = false;
  }

  get hiddenClassWithDefault() {
    return this.hasHiddenClass ? this.hiddenClass : "hidden";
  }

  disconnect() {
    clearTimeout(this.searchTimeout);
  }
}
