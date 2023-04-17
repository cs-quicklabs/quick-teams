import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["comment"]

    counter = 0;
    connect() {
        const url = window.location.href;
        if (url.includes("#")) {
            const comment = url.substring(url.lastIndexOf("_") + 1)
            const item = this.commentTargets.find((item) => item.dataset.commentId == comment)
            if (item) {
                if (item.classList.contains("hidden")) {
                    item.classList.remove("hidden")
                    item.scrollIntoView({ behavior: "smooth", block: "center", inline: "center" })
                } else {
                    item.scrollIntoView({ behavior: "smooth", block: "center", inline: "center" })
                }
            }
        }
        const hiddenComments = this.commentTargets.filter((comment) => comment.classList.contains("hidden"))
        if (!hiddenComments.length > 0) {
            document.getElementById("load-comments").style.display = "none"
        }
    }
    toggleComments(event) {
        event.preventDefault()

        this.commentTargets.reverse().forEach((comments, index) => {
            if (index < this.counter + 10) {
                comments.classList.remove("hidden")

            } else {
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