import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link", "trigger", "content"]
  static classes = ["active"]

  connect() {
    this.activeTriggerId = null
    this.onScroll()
  }

  scrollTo(event) {
    const href = event.currentTarget.getAttribute('href')
    if (!href) return

    const targetId = href.replace('#', '')
    const targetElement = document.getElementById(targetId)

    if (targetElement) {
      event.preventDefault()

      targetElement.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
      })

      // Update URL without jumping
      history.pushState(null, '', href)
    }
  }

  onScroll() {
    // Get the middle of the viewport relative to the content
    const contentRect = this.contentTarget.getBoundingClientRect()
    const middleOfScreen = contentRect.top + (contentRect.height / 4)

    let newActiveTriggerId = null
    let closestDistance = Infinity

    // OPTIMIZE: worth caching much of this to avoid too much work onScroll?
    // Find which trigger is closest to the middle of the screen
    this.triggerTargets.forEach(trigger => {
      const triggerRect = trigger.getBoundingClientRect()
      const triggerMiddle = triggerRect.top + (triggerRect.height / 4)
      const distance = Math.abs(triggerMiddle - middleOfScreen)

      if (distance < closestDistance) {
        closestDistance = distance
        newActiveTriggerId = trigger.id
      }
    })

    // Only update DOM if the active section changed
    if (newActiveTriggerId !== this.activeTriggerId) {
      this.activeTriggerId = newActiveTriggerId

      // Update active states on links
      this.linkTargets.forEach(link => {
        const href = link.getAttribute('href')
        const targetId = href ? href.replace('#', '') : null

        if (targetId === this.activeTriggerId) {
          link.classList.add(this.activeClass)
        } else {
          link.classList.remove(this.activeClass)
        }
      })
    }
  }
}

