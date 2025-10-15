import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static classes = ["active", "hidden"]

  get activeClassWithDefault() {
    return this.hasActiveClass ? this.activeClass : "active"
  }

  get hiddenClassWithDefault() {
    return this.hasHiddenClass ? this.hiddenClass : "hidden"
  }

  switch(event) {
    const clickedTab = event.currentTarget
    this.showPanel(clickedTab.dataset.panelId)
  }

  showPanel(panelId) {
    // mark the current tab as active
    this.tabTargets.forEach(tab => {
      tab.classList.toggle(this.activeClassWithDefault, tab.dataset.panelId === panelId)
    })

    // hide all panels except the current one
    this.panelTargets.forEach(panel => {
      panel.classList.toggle(this.hiddenClassWithDefault, panel.dataset.panelId !== panelId)
    })
  }
}
