import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "trigger", "menu" ]

  connect() {
    this.boundClickOutside = this.clickOutside.bind(this);
    this.boundKeydown = this.keydown.bind(this);
  }

  disconnect() {
    document.removeEventListener('click', this.boundClickOutside);
    document.removeEventListener('keydown', this.boundKeydown);
  }

  toggle() {
    if (this.element.classList.contains('open')) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.element.classList.add('open');

    // Add event listeners when dropdown is shown
    document.addEventListener('click', this.boundClickOutside);
    document.addEventListener('keydown', this.boundKeydown);
  }

  close() {
    this.element.classList.remove('open');

    // Remove event listeners when dropdown is hidden
    document.removeEventListener('click', this.boundClickOutside);
    document.removeEventListener('keydown', this.boundKeydown);
  }

  clickOutside(event) {
    // Check if the click is outside the dropdown element
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  keydown(event) {
    // Close dropdown on Escape key
    if (event.key === 'Escape') {
      this.close();
    }
  }
}
