import { Controller } from "@hotwired/stimulus"
import { setCookie, deleteCookie } from "helpers"

export default class extends Controller {
  static targets = ["container", "toggle"]
  static classes = [ "on", "open" ]
  static values = { closedCookie: String }

  connect() {
    // Initial state is set by ERB template based on cookie
    // Just ensure the toggle button reflects the current state
    this.refresh();
  }

  get isOpen() {
    return this.containerTarget.classList.contains(this.openClassWithDefault);
  }

  get onClassWithDefault() {
    return this.hasOnClass ? this.onClass : "on";
  }

  get openClassWithDefault() {
    return this.hasOpenClass ? this.openClass : "open";
  }

  toggle() {
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.containerTarget.classList.add(this.openClassWithDefault);
    this.closedCookieValue && deleteCookie(this.closedCookieValue);
    this.refresh();
  }

  close() {
    this.containerTarget.classList.remove(this.openClassWithDefault);
    this.closedCookieValue && setCookie(this.closedCookieValue, "1", 7); // Save for 7 days
    this.refresh();
  }

  refresh() {
    this.toggleTarget.classList.toggle(this.onClassWithDefault, this.isOpen);
  }
}
