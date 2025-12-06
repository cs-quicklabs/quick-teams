// Configure your import map in config/importmap.rb
console.log("Application.js starting...");

// Turbo must be imported first as other modules depend on it
import "@hotwired/turbo-rails"
console.log("Turbo imported");

// Load channels for ActionCable
import "channels"
console.log("Channels imported");

// Load config (StimulusReflex, CableReady) BEFORE controllers
// so StimulusReflex is initialized before controllers try to register
import "config"
console.log("Config imported");

// Then load controllers which set up Stimulus
import "controllers"
console.log("Controllers imported");

// Rails libraries
import "@rails/actiontext"
import "@rails/activestorage"
console.log("Rails libraries imported");

// Trix editor
import "trix"
import "trix-editor-overrides"

import Trix from "trix"

Trix.config.textAttributes.highlight = { tagName: "mark" };

addEventListener("trix-initialize", function (event) {
    var groupElement = event.target.toolbarElement.querySelector(".trix-button-group.trix-button-group--text-tools")

    groupElement.insertAdjacentHTML("beforeend", '<button type="button" class="trix-button trix-button--icon trix-button--icon-highlight" data-trix-attribute="highlight" data-trix-key="y" title="Highlight" tabindex="-1">${lang.highlight}')

})

