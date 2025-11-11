import { Controller } from "@hotwired/stimulus"
import { setCookie, deleteCookie, isDesktop } from "helpers"

export default class extends Controller {
  static classes = [ "open", "desktop-open" ]
  static values = {
    closedCookie: String,
    closedCookieDays: { type: Number, default: 7 }
  }

  connect() {
    // Since space is limited outside of desktop, ensure we start closed regardless of server-side open class
    // TODO: perform something like this on resize (when existing/entering desktop width)
    if (!isDesktop() && this.isOpen) {
      this.element.classList.remove(this.desktopOpenClassWithDefault);
      this._syncToggleButtons(false);
    }

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

  get desktopOpenClassWithDefault() {
    return this.hasDesktopOpenClass ? this.desktopOpenClass : "desktop-open";
  }

  get isOpen() {
    if (!isDesktop()) {
      return this.element.classList.contains(this.desktopOpenClassWithDefault);
    }
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
    const cssClass = isDesktop() ? this.desktopOpenClassWithDefault : this.openClassWithDefault;
    this.element.classList.toggle(cssClass, open);

    // Cookie behavior only applies on desktop
    if (!(isDesktop() && this.hasClosedCookieValue)) {
      // no-op
    } else if (open) {
      deleteCookie(this.closedCookieValue);
    } else {
      setCookie(this.closedCookieValue, "1", this.closedCookieDaysValue);
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
