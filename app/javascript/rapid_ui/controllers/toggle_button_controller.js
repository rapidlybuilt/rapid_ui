import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { target: String }
  static classes = [ "on", "off" ]

  get onClassWithDefault() {
    return this.hasOnClass ? this.onClass : "on";
  }

  get offClassWithDefault() {
    return this.hasOffClass ? this.offClass : "";
  }

  get isOn() {
    return this.onClassWithDefault.split(" ").every(cls =>
      cls.length > 0 && this.element.classList.contains(cls)
    );
  }

  get isOff() {
    return !this.isOn;
  }

  toggle() {
    if (this.isOn) {
      this.off();
    } else {
      this.on();
    }
  }

  on() {
    this.setOpen(true);
    this._dispatchToggleEvent(true);
  }

  off() {
    this.setOpen(false);
    this._dispatchToggleEvent(false);
  }

  setOpen(on) {
    // Toggle on classes
    const onClasses = this.onClassWithDefault.split(" ").filter(c => c.length > 0);
    onClasses.forEach(cls => this.element.classList.toggle(cls, on));

    // Toggle off classes
    const offClasses = this.offClassWithDefault.split(" ").filter(c => c.length > 0);
    offClasses.forEach(cls => this.element.classList.toggle(cls, !on));
  }

  _dispatchToggleEvent(isOpen) {
    const event = new CustomEvent("toggle-button:toggled", {
      detail: {
        isOpen,
        target: this.hasTargetValue ? this.targetValue : null,
        source: this.element
      },
      bubbles: true,
      cancelable: true
    });
    document.dispatchEvent(event);
  }
}
