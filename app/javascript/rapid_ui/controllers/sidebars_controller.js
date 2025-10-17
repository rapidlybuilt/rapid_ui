import { Controller } from "@hotwired/stimulus"
import { setCookie, deleteCookie } from "helpers"

export default class extends Controller {
  static targets = ["container", "toggle"]
  static classes = [ "on", "open" ]

  connect() {
    // Initial state is set by ERB template based on cookie
    // Just ensure all toggle buttons reflect the current state
    this.refreshAll();
  }

  get onClassWithDefault() {
    return this.hasOnClass ? this.onClass : "on";
  }

  get openClassWithDefault() {
    return this.hasOpenClass ? this.openClass : "open";
  }

  // Get the sidebar ID from the event target's data attribute
  getSidebarId(element) {
    return element.dataset.sidebarId || element.closest('[data-sidebar-id]')?.dataset.sidebarId;
  }

  // Get the container for a specific sidebar ID
  getContainer(sidebarId) {
    return this.containerTargets.find(container => container.dataset.sidebarId === sidebarId);
  }

  // Get all toggles for a specific sidebar ID
  getToggles(sidebarId) {
    return this.toggleTargets.filter(toggle => this.getSidebarId(toggle) === sidebarId);
  }

  // Check if a specific sidebar is open
  isOpen(sidebarId) {
    const container = this.getContainer(sidebarId);
    return container?.classList.contains(this.openClassWithDefault) || false;
  }

  // Get the closed cookie name for a specific sidebar
  getClosedCookie(sidebarId) {
    const container = this.getContainer(sidebarId);
    return container?.dataset.sidebarClosedCookie;
  }

  open(event) {
    this.setOpen(event.currentTarget, true);
  }

  close(event) {
    this.setOpen(event.currentTarget, false);
  }

  toggle(event) {
    const sidebarId = this.getSidebarId(event.currentTarget);
    if (!sidebarId) return;

    if (this.isOpen(sidebarId)) {
      this.close(event);
    } else {
      this.open(event);
    }
  }

  refresh(sidebarId) {
    const isOpen = this.isOpen(sidebarId);
    const toggles = this.getToggles(sidebarId);

    toggles.forEach(toggle => {
      const onClasses = (toggle.dataset.sidebarToggleOnClass || this.onClassWithDefault).split(" ");
      onClasses.forEach(cls => toggle.classList.toggle(cls, isOpen));

      const offClasses = toggle.dataset.sidebarToggleOffClass?.split(" ");
      offClasses?.forEach(cls => toggle.classList.toggle(cls, !isOpen));
    });
  }

  refreshAll() {
    // Get unique IDs from all containers
    const sidebarIds = [...new Set(this.containerTargets.map(c => c.dataset.sidebarId))];
    sidebarIds.forEach(sidebarId => this.refresh(sidebarId));
  }

  setOpen(target, open) {
    const sidebarId = this.getSidebarId(target);
    if (!sidebarId) return;

    const container = this.getContainer(sidebarId);
    if (!container) return;

    container.classList.toggle(this.openClassWithDefault, open);

    const closedCookie = this.getClosedCookie(sidebarId);
    if (!closedCookie) {
      // no-op
    } else if (open) {
      deleteCookie(closedCookie);
    } else {
      setCookie(closedCookie, "1", 7); // Save for 7 days
    }

    this.refresh(sidebarId);
  }
}
