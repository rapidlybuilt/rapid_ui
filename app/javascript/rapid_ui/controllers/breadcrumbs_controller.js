import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "flat", "small", "tiny" ]

  connect() {
    this.requiredFlatWidth = this.calculateRequiredWidth(this.flatTarget);
    this.requiredSmallWidth = this.calculateRequiredWidth(this.smallTarget);

    this.boundHandleResize = this.handleResize.bind(this);
    window.addEventListener("resize", this.boundHandleResize);

    console.log(this.requiredFlatWidth, this.requiredSmallWidth);
    this.handleResize();
  }

  disconnect() {
    window.removeEventListener("resize", this.boundHandleResize);
  }

  get gapSize() {
    if (!this.calculatedGapSize) {
      this.calculatedGapSize = parseFloat(getComputedStyle(this.flatTarget).gap);
    }

    return this.calculatedGapSize;
  }

  handleResize() {
    let hideFlat = true;
    let hideSmall = true;
    let hideTiny = true;

    const allowedWidth = this.element.clientWidth;

    if (allowedWidth > this.requiredFlatWidth) {
      hideFlat = false;
    } else if (allowedWidth > this.requiredSmallWidth) {
      hideSmall = false;
    } else {
      hideTiny = false;
    }

    this.flatTarget.classList.toggle("hidden", hideFlat);
    this.smallTarget.classList.toggle("hidden", hideSmall);
    this.tinyTarget.classList.toggle("hidden", hideTiny);
    console.log([allowedWidth, this.requiredFlatWidth, this.requiredSmallWidth, hideFlat, hideSmall, hideTiny]);
  }

  calculateRequiredWidth(target) {
    // HACK: calculate the required width by showing the content w/ no visibility
    const prevVisibility = target.style.visibility;
    const prevDisplay = target.style.display;

    target.style.visibility = 'hidden'; // won’t flash
    target.style.display = 'flex';

    const children = Array.from(target.children);

    // width of each child + gaps between children
    const width = children.reduce((acc, child) => acc + child.clientWidth, 0) + (children.length - 1) * this.gapSize;

    target.style.visibility = prevVisibility;
    target.style.display = prevDisplay;

    return width;
  }
}
