import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Typography link hover handlers
  hoverLink(event) {
    const link = event.currentTarget;
    const hoverColor = link.dataset.themesHoverColor;
    if (hoverColor) {
      link.style.color = hoverColor;
    }
  }

  unhoverLink(event) {
    const link = event.currentTarget;
    const defaultColor = link.dataset.themesDefaultColor;
    if (defaultColor) {
      link.style.color = defaultColor;
    }
  }

  // Button hover handlers
  hoverButton(event) {
    const button = event.currentTarget;
    const hoverText = button.dataset.themesHoverText;
    const hoverBg = button.dataset.themesHoverBg;
    const hoverBorder = button.dataset.themesHoverBorder;

    if (hoverText) button.style.color = hoverText;
    if (hoverBg) button.style.backgroundColor = hoverBg;
    if (hoverBorder) button.style.borderColor = hoverBorder;
  }

  unhoverButton(event) {
    const button = event.currentTarget;
    const defaultText = button.dataset.themesDefaultText;
    const defaultBg = button.dataset.themesDefaultBg;
    const defaultBorder = button.dataset.themesDefaultBorder;

    if (defaultText) button.style.color = defaultText;
    if (defaultBg) button.style.backgroundColor = defaultBg;
    if (defaultBorder) button.style.borderColor = defaultBorder;
  }
}
