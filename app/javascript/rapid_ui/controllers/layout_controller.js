import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("layout_controller connected");
  }
}
