import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Three different modes for different screen sizes
  static targets = [ "fullList", "firstLastDropdownList", "dropdownList" ]

  connect() {
    this.requiredFullListWidth = this.calculateRequiredWidth(this.fullListTarget);
    this.requiredFirstLastDropdownListWidth = this.calculateRequiredWidth(this.firstLastDropdownListTarget);

    this.boundHandleResize = this.handleResize.bind(this);
    window.addEventListener("resize", this.boundHandleResize);

    this.handleResize();
  }

  disconnect() {
    window.removeEventListener("resize", this.boundHandleResize);
  }

  get gapSize() {
    if (!this.calculatedGapSize) {
      this.calculatedGapSize = parseFloat(getComputedStyle(this.fullListTarget).gap);
    }

    return this.calculatedGapSize;
  }

  handleResize() {
    let hideFullList = true;
    let hideDropdownList = true;
    let hideFirstLastDropdownList = true;

    const allowedWidth = this.element.clientWidth;

    if (allowedWidth > this.requiredFullListWidth) {
      hideFullList = false;
    } else if (allowedWidth > this.requiredFirstLastDropdownListWidth) {
      hideFirstLastDropdownList = false;
    } else {
      hideDropdownList = false;
    }

    this.fullListTarget.classList.toggle("hidden", hideFullList);
    this.dropdownListTarget.classList.toggle("hidden", hideDropdownList);
    this.firstLastDropdownListTarget.classList.toggle("hidden", hideFirstLastDropdownList);
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
