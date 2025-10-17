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
    this._setState(true);
    this._fireEvent("open");
  }

  close() {
    this._setState(false);
    this._fireEvent("close");
  }

  _setState(open) {
    this.element.classList.toggle(this.openClassWithDefault, open);

    if (!this.hasClosedCookieValue) {
      // no-op
    } else if (open) {
      deleteCookie(this.closedCookieValue);
    } else {
      setCookie(this.closedCookieValue, "1", 7); // Save for 7 days
    }
  }

  _fireEvent(event) {
  }
}
