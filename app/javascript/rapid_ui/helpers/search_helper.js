import { makeXHRRequest } from "helpers"

/** TODO: what is in search bar / search page can be shared via this helper? */

/**
 * SearchHelper - Shared search functionality for static search indexes
 *
 * Handles fetching, searching, and rendering static search results
 */
export class SearchHelper {
  constructor(options = {}) {
    this.staticPath = options.staticPath;
    this.resultTemplate = options.resultTemplate;

    this.staticIndex = [];
    this.staticIndexLoaded = false;
    this.staticIndexLoading = false;
  }

  /**
   * Fetch static search index from server
   * @returns {Promise<Array>} The loaded static index
   */
  async fetchStaticIndex() {
    // Already loaded or currently loading
    if (this.staticIndexLoaded || this.staticIndexLoading) {
      return this.staticIndex;
    }

    // No static path configured
    if (!this.staticPath) {
      return this.staticIndex;
    }

    this.staticIndexLoading = true;

    try {
      const responseText = await makeXHRRequest(this.staticPath, {
        method: 'GET',
        params: {},
        headers: { 'Accept': 'application/json' }
      });
      this.staticIndex = JSON.parse(responseText);
      this.staticIndexLoaded = true;
    } catch (error) {
      console.error("Failed to load static search index:", error);
      this.staticIndex = [];
    } finally {
      this.staticIndexLoading = false;
    }

    return this.staticIndex;
  }

  /**
   * Search the static index for matching results
   * @param {string} query - Search query
   * @returns {Array} Filtered results matching the query
   */
  searchStaticIndex(query) {
    if (!query || query.length === 0) {
      return [];
    }

    if (!this.staticIndexLoaded || this.staticIndex.length === 0) {
      return [];
    }

    const lowerQuery = query.toLowerCase();

    return this.staticIndex.filter(item => {
      const titleMatch = item.title?.toLowerCase().includes(lowerQuery);
      const descMatch = item.description?.toLowerCase().includes(lowerQuery);
      return titleMatch || descMatch;
    });
  }

  /**
   * Render search results as a DocumentFragment
   * @param {Array} results - Array of result objects
   * @returns {DocumentFragment} Fragment containing rendered results
   */
  renderResults(results) {
    const fragment = document.createDocumentFragment();

    results.forEach(result => {
      const resultElement = this.createResultElement(result);
      fragment.appendChild(resultElement);
    });

    return fragment;
  }

  /**
   * Create a single result element from template
   * @param {Object} result - Result object with title, url, description
   * @returns {Element} Cloned and populated result element
   */
  createResultElement(result) {
    if (!this.resultTemplate) {
      throw new Error("SearchHelper: resultTemplate is required for rendering results");
    }

    const template = this.resultTemplate.content;
    const element = template.cloneNode(true).firstElementChild;

    // Set URL
    element.href = result.url;

    // Set title
    const titleEl = element.querySelector('.search-result-title');
    titleEl.textContent = result.title;

    // Set description (hide if empty)
    const descEl = element.querySelector('.search-result-description');
    if (result.description) {
      descEl.textContent = result.description;
    } else {
      descEl.remove();
    }

    return element;
  }
}
