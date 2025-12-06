import { application } from "controllers/application"
import StimulusReflex, { StimulusReflexController as BaseStimulusReflexController } from "stimulus_reflex"

// Create a custom controller that has __perform on its prototype
class StimulusReflexController extends BaseStimulusReflexController {
    __perform(event) {
        // This method is added dynamica88 StimulusReflex.register()
        // but we need it on the prototype for Stimulus action binding
        if (this.stimulate) {
            let element = event.target
            let reflex
            while (element && !reflex) {
                reflex = element.getAttribute("data-reflex")
                if (!reflex || !reflex.trim().length) {
                    element = element.parentElement
                }
            }
            const match = reflex.split(" ").find(r => r.split("->")[0] === event.type)
            if (match) {
                event.preventDefault()
                event.stopPropagation()
                this.stimulate(match.split("->")[1], element)
            }
        }
    }
}

StimulusReflex.initialize(application, { controller: StimulusReflexController, isolate: true })

// consider removing these options in production
StimulusReflex.debug = true
// end remove
