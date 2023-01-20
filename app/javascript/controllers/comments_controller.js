import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["comment"]

    counter = 0;
    toggleComments(event) {
        event.preventDefault()

        this.commentTargets.reverse().forEach((comments, index) => {
            if (index < this.counter + 10) {
                comments.classList.remove("hidden")

            } else {
                console.log("hidden")
                comments.classList.add("hidden")
            }

        });
        this.counter += 10;
        if (this.counter >= this.commentTargets.length) {
            document.getElementById("load-comments").style.display = "none"
            return;
        }
    }
}