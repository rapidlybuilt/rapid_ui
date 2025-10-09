import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "toggleButton"]
  static classes = [ "sidebar-on", "sidebar-open" ]

  connect() {
    // ensure that the toggle button is in the correct state
    this.updateSidebarToggleButton();
  }

  get isSidebarOpen() {
    return this.sidebarTarget.classList.contains(this.sidebarOpenClassWithDefault);
  }

  get sidebarOnClassWithDefault() {
    return this.hasSidebarOnClass ? this.sidebarOnClass : "on";
  }

  get sidebarOpenClassWithDefault() {
    return this.hasSidebarOpenClass ? this.sidebarOpenClass : "open";
  }

  toggleSidebar() {
    if (this.isSidebarOpen) {
      this.closeSidebar();
    } else {
      this.openSidebar();
    }
  }

  openSidebar() {
    this.sidebarTarget.classList.add(this.sidebarOpenClassWithDefault);
    this.updateSidebarToggleButton();
  }

  closeSidebar() {
    this.sidebarTarget.classList.remove(this.sidebarOpenClassWithDefault);
    this.updateSidebarToggleButton();
  }

  updateSidebarToggleButton() {
    this.toggleButtonTarget.classList.toggle(this.sidebarOnClassWithDefault, this.isSidebarOpen);
  }
}
