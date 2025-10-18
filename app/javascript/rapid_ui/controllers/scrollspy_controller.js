import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link", "trigger", "content"]
  static classes = ["active"]

  connect() {
    this.onScroll()
  }

  onScroll() {
    // Get the middle of the viewport relative to the content
    const contentRect = this.contentTarget.getBoundingClientRect()
    const middleOfScreen = contentRect.top + (contentRect.height / 4)

    let activeTriggerId = null
    let closestDistance = Infinity

    // Find which trigger is closest to the middle of the screen
    this.triggerTargets.forEach(trigger => {
      const triggerRect = trigger.getBoundingClientRect()
      const triggerMiddle = triggerRect.top + (triggerRect.height / 4)
      const distance = Math.abs(triggerMiddle - middleOfScreen)

      if (distance < closestDistance) {
        closestDistance = distance
        activeTriggerId = trigger.id
      }
    })

    // Update active states on links
    this.linkTargets.forEach(link => {
      const href = link.getAttribute('href')
      const targetId = href ? href.replace('#', '') : null

      if (targetId === activeTriggerId) {
        link.classList.add(this.activeClass)
      } else {
        link.classList.remove(this.activeClass)
      }
    })
  }
}

