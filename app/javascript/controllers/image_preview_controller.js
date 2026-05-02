import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "cancelButton"]

  connect() {
    this.originalSrc = this.previewTarget.src
    this.wasHidden = this.previewTarget.classList.contains("d-none")
  }

  preview() {
    const file = this.inputTarget.files[0]

    if (file) {
      this.previewTarget.src = URL.createObjectURL(file)
      this.previewTarget.classList.remove("d-none")
      this.cancelButtonTarget.classList.remove("d-none")
    }
  }

  reset(event) {
    event.preventDefault()

    this.inputTarget.value = ""
    
    this.previewTarget.src = this.originalSrc
    
    if (this.wasHidden) {
      this.previewTarget.classList.add("d-none")
    }
    
    this.cancelButtonTarget.classList.add("d-none")
  }
}