import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static classes = ["expanded"]

  get expandedClassWithDefault() {
    return this.hasExpandedClass ? this.expandedClass : "expanded"
  }

  get contentWithDefault() {
    return this.hasContentTarget ? this.contentTarget : this.element
  }

  toggle() {
    const content = this.contentWithDefault
    content.classList.toggle(this.expandedClassWithDefault)
  }

  open() {
    const content = this.contentWithDefault
    content.classList.add(this.expandedClassWithDefault)
  }

  close() {
    const content = this.contentWithDefault
    content.classList.remove(this.expandedClassWithDefault)
  }
}
