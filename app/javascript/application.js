// Entry point for the build script in your package.json
import "./controllers"
import "./channels"
import "./config"
import 'trix'
import '@rails/actiontext'
import '@rails/activestorage'
import '@tailwindcss/line-clamp'
import '@tailwindcss/forms'
import "@hotwired/turbo-rails"
import "./trix-editor-overrides"


import Trix from "trix"

Trix.config.textAttributes.highlight = { tagName: "mark" };

addEventListener("trix-initialize", function (event) {
    var groupElement = event.target.toolbarElement.querySelector(".trix-button-group.trix-button-group--text-tools")

    groupElement.insertAdjacentHTML("beforeend", '<button type="button" class="trix-button trix-button--icon trix-button--icon-highlight" data-trix-attribute="highlight" data-trix-key="y" title="Highlight" tabindex="-1">${lang.highlight}')

})

