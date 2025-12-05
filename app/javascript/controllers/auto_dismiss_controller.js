import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-dismiss"
export default class extends Controller {
    static values = {
        delay: { type: Number, default: 2000 }
    }

    connect() {
        this.timeout = setTimeout(() => {
            this.dismiss()
        }, this.delayValue)
    }

    disconnect() {
        if (this.timeout) {
            clearTimeout(this.timeout)
        }
    }

    dismiss() {
        this.element.classList.add('hidden')
    }
}
