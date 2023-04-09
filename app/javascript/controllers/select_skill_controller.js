import { Controller } from "@hotwired/stimulus"
import StimulusReflex from 'stimulus_reflex';

export default class extends Controller {
  static targets = ['selected']




 toggleSelected(event) {
  event.preventDefault();
  const url = event.target.closest('a').href;
  const target=event.target.closest('li')
  fetch(url, { headers: { "Accept": "text/vnd.turbo-stream.html" } })
  .then(response => response.text())
  .then(html => {
    target.innerHTML = html
  })
}
}