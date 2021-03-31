import { Controller } from "stimulus"

export default class extends Controller {

    close() {
        this.element.remove()
    }

    escClose(event) {
        if (event.key === 'Escape') this.close()
    }

}