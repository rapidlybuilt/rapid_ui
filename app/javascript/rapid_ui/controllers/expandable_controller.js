import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  get contentWithDefault() {
    return this.hasContentTarget ? Array.from(this.contentTargets) : [this.element]
  }

  hiddenClassWithDefault(content) {
    return content.dataset.expandableHiddenClass?.split(" ") || ["hidden"]
  }

  toggle(e) {
    e?.preventDefault();

    this.contentWithDefault.forEach(content => {
      this.hiddenClassWithDefault(content).forEach(cls => {
        content.classList.toggle(cls)
      })
    })
  }

  open(e) {
    e?.preventDefault();

    this.contentWithDefault.forEach(content => {
      this.hiddenClassWithDefault(content).forEach(cls => {
        content.classList.remove(cls)
      })
    })
  }

  close(e) {
    e?.preventDefault();

    this.contentWithDefault.forEach(content => {
      this.hiddenClassWithDefault(content).forEach(cls => {
        content.classList.add(cls)
      })
    })
  }
}
