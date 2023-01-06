import { Controller } from '@hotwired/stimulus';
import SlimSelect from 'slim-select';
//import 'slim-select/dist/slimselect.css';

export default class extends Controller {
  static values = {
    options: Object
  };

  connect() {
    this.slimselect = new SlimSelect({
      select: this.element,
      ...this.optionsValue
    });
  }

  disconnect() {
    this.slimselect.destroy();
  }

}
