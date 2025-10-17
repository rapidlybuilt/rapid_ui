import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
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
    this.setState(true);
  }

  off() {
    this.setState(false);
  }

  setState(on) {
    // Toggle on classes
    const onClasses = this.onClassWithDefault.split(" ").filter(c => c.length > 0);
    onClasses.forEach(cls => this.element.classList.toggle(cls, on));

    // Toggle off classes
    const offClasses = this.offClassWithDefault.split(" ").filter(c => c.length > 0);
    offClasses.forEach(cls => this.element.classList.toggle(cls, !on));
  }
}
