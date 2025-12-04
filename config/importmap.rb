# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/config", under: "config"

# Hotwire
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Rails
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "@rails/request.js", to: "https://ga.jspm.io/npm:@rails/request.js@0.0.11/src/index.js"

# Trix editor
pin "trix", to: "https://ga.jspm.io/npm:trix@2.1.8/dist/trix.esm.min.js"

# StimulusReflex and CableReady
pin "stimulus_reflex", to: "https://ga.jspm.io/npm:stimulus_reflex@3.5.2/dist/stimulus_reflex.js"
pin "cable_ready", to: "https://ga.jspm.io/npm:cable_ready@5.0.6/dist/cable_ready.js"
pin "morphdom", to: "https://ga.jspm.io/npm:morphdom@2.7.4/dist/morphdom-esm.js"

# Slim Select
pin "slim-select", to: "https://ga.jspm.io/npm:slim-select@2.9.2/dist/slimselect.es.js"

# Stimulus plugins
pin "stimulus-scroll-to", to: "https://ga.jspm.io/npm:stimulus-scroll-to@4.1.0/dist/stimulus-scroll-to.mjs"
