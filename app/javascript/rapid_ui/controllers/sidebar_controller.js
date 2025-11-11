import { Controller } from "@hotwired/stimulus"
import { setCookie, deleteCookie, isLarge } from "helpers"

// TODO: allow users to adjust sidebars widths on desktop/tablet
// TODO: only one sidebar should be open at a time on each side
// TODO: sidebar option for full-screen width on mobile

export default class extends Controller {
  static classes = [ "open", "open-lg" ]
  static values = {
    closedCookie: String,
    closedCookieDays: { type: Number, default: 7 }
  }

  connect() {
    // Since space is limited outside of desktop, ensure we start closed regardless of server-side open class
    // TODO: perform something like this on resize (when existing/entering desktop width)
    if (!isLarge() && this.isOpen) {
      this.element.classList.remove(this.desktopOpenClassWithDefault);

      // HACK: race-condition on when the toggle button is connected
      this._syncToggleButtons(false) || setTimeout(() => this._syncToggleButtons(false), 100);
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
    return this.hasDesktopOpenClass ? this.desktopOpenClass : "open-lg";
  }

  get isOpen() {
    if (!isLarge()) {
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
    const cssClass = isLarge() ? this.desktopOpenClassWithDefault : this.openClassWithDefault;
    this.element.classList.toggle(cssClass, open);

    // Cookie behavior only applies on desktop
    if (!(isLarge() && this.hasClosedCookieValue)) {
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
    let count = 0;

    // HACK: Find all toggle buttons that target this sidebar and sync their state
    const selector = `[data-controller~="toggle-button"][data-toggle-button-target-value="${this.element.id}"]`;
    document.querySelectorAll(selector).forEach(toggle => {
      const toggleButtonController = this.application.getControllerForElementAndIdentifier(toggle, "toggle-button");
      if (toggleButtonController) {
        toggleButtonController.setOpen(isOpen);
        count++;
      }
    });

    return count;
  }
}
