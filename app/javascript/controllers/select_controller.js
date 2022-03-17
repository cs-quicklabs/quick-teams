import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["select"]
  static values = {
    url: String,
    param: String
  }

  change(event) {
    let params = new URLSearchParams()
    params.append(this.paramValue, event.target.selectedOptions[0].value)
    params.append("target", this.selectTarget.id)
    const target = `${this.selectTarget.id}`
    const headers = { 'X-Requested-With': 'XMLHttpRequest', 'Accept': 'text/vnd.turbo-stream.html', responseKind: 'turbo-stream' }
    fetch(`${this.urlValue}?${params}`, { headers })
      .then((response) => response.text())
      .then((response) => {
        this.selectTarget.innerHTML = response;
      })

      .catch((error) => {
        console.log('error:', error);
      });
  }
}