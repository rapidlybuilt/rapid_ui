import { Controller } from "@hotwired/stimulus"
import { setCookie, deleteCookie } from "helpers"

export default class extends Controller {
  static classes = [ "open" ]
  static values = { closedCookie: String }

  connect() {
    // Listen for toggle button events
    this._boundHandleToggle = this.handleToggleButtonEvent.bind(this);
    document.addEventListener("toggle-button:toggled", this._boundHandleToggle);

    this._syncToggleButtons(this.isOpen);
  }

  disconnect() {
    // Clean up event listener
    document.removeEventListener("toggle-button:toggled", this._boundHandleToggle);
  }

  get openClassWithDefault() {
    return this.hasOpenClass ? this.openClass : "open";
  }

  get isOpen() {
    return this.element.classList.contains(this.openClassWithDefault);
  }

  toggle() {
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.setOpen(true);
    this._syncToggleButtons(true);
  }

  close() {
    this.setOpen(false);
    this._syncToggleButtons(false);
  }

  setOpen(open) {
    this.element.classList.toggle(this.openClassWithDefault, open);

    if (!this.hasClosedCookieValue) {
      // no-op
    } else if (open) {
      deleteCookie(this.closedCookieValue);
    } else {
      setCookie(this.closedCookieValue, "1", 7); // Save for 7 days
    }
  }

  handleToggleButtonEvent(event) {
    const { target, isOpen } = event.detail;

    if (target !== this.element.id) {
      return;
    }

    this.setOpen(isOpen);
  }

  _syncToggleButtons(isOpen) {
    // HACK: Find all toggle buttons that target this sidebar and sync their state
    const selector = `[data-controller~="toggle-button"][data-toggle-button-target-value="${this.element.id}"]`;
    document.querySelectorAll(selector).forEach(toggle => {
      const toggleButtonController = this.application.getControllerForElementAndIdentifier(toggle, "toggle-button");
      if (toggleButtonController) {
        toggleButtonController.setOpen(isOpen);
      }
    });
  }
}
