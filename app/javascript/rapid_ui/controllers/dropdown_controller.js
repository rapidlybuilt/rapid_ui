import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "content" ]
  static classes = [ "hidden" ]
  static values = { path: String }

  connect() {
    this.contentLoaded = false;
    this.boundClickOutside = this.clickOutside.bind(this);
    this.boundKeydown = this.keydown.bind(this);
  }

  disconnect() {
    document.removeEventListener('click', this.boundClickOutside);
    document.removeEventListener('keydown', this.boundKeydown);
  }

  get hiddenClassWithDefault() {
    return this.hasHiddenClass ? this.hiddenClass : "hidden";
  }

  toggle() {
    if (this.contentTarget.classList.contains(this.hiddenClassWithDefault)) {
      this.show();
    } else {
      this.hide();
    }
  }

  hide() {
    this.contentTarget.classList.add(this.hiddenClassWithDefault);

    // Remove event listeners when dropdown is hidden
    document.removeEventListener('click', this.boundClickOutside);
    document.removeEventListener('keydown', this.boundKeydown);
  }

  show() {
    this.contentTarget.classList.remove(this.hiddenClassWithDefault);

    // Add event listeners when dropdown is shown
    document.addEventListener('click', this.boundClickOutside);
    document.addEventListener('keydown', this.boundKeydown);

    // Optionally load content from path if configured and not already loaded
    if (this.hasPathValue && this.pathValue && !this.contentLoaded) {
      this.loadContent();
    }
  }

  async loadContent() {
    try {
      const response = await fetch(this.pathValue);
      if (response.ok) {
        const content = await response.text();
        this.contentTarget.innerHTML = content;
        this.contentLoaded = true;
      }
    } catch (error) {
      console.error('Failed to load dropdown content:', error);
    }
  }

  clickOutside(event) {
    // Check if the click is outside the dropdown element
    if (!this.element.contains(event.target)) {
      this.hide();
    }
  }

  keydown(event) {
    // Close dropdown on Escape key
    if (event.key === 'Escape') {
      this.hide();
    }
  }
}
