import { Controller } from "@hotwired/stimulus"
import { setCookie, deleteCookie } from "helpers"

export default class extends Controller {
  static classes = [ "open" ]
  static values = { closedCookie: String }

  get onClassWithDefault() {
    return this.hasOnClass ? this.onClass : "on";
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
    this._fireEvent(true);
  }

  close() {
    this.setOpen(false);
    this._fireEvent(false);
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

  _fireEvent(isOpen) {
    // TODO: this is out of scope of this controller.  Use events instead.
    const selector = `[data-controller="toggle-button"][data-toggle-button-sidebar-value="${this.element.id}"]`;
    document.querySelectorAll(selector).forEach(toggle => {
      const toggleButtonController = this.application.getControllerForElementAndIdentifier(toggle, "toggle-button");
      if (toggleButtonController) {
        toggleButtonController.setOpen(isOpen);
      }
    });
  }
}
