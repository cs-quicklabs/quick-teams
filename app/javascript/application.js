// Configure your import map in config/importmap.rb
// Turbo must be imported first as other modules depend on it
import "@hotwired/turbo-rails"

// Then load controllers which set up Stimulus
import "controllers"

// Load channels for ActionCable
import "channels"

// Load config (StimulusReflex, CableReady) after Turbo and controllers
import "config"

// Rails libraries
import "@rails/actiontext"
import "@rails/activestorage"

// Trix editor
import "trix"
import "trix-editor-overrides"

import Trix from "trix"

Trix.config.textAttributes.highlight = { tagName: "mark" };

addEventListener("trix-initialize", function (event) {
    var groupElement = event.target.toolbarElement.querySelector(".trix-button-group.trix-button-group--text-tools")

    groupElement.insertAdjacentHTML("beforeend", '<button type="button" class="trix-button trix-button--icon trix-button--icon-highlight" data-trix-attribute="highlight" data-trix-key="y" title="Highlight" tabindex="-1">${lang.highlight}')

})

