import { Controller } from '@hotwired/stimulus';
//import SlimSelect from 'slim-select';

export default class extends Controller {
    static values = {
        options: Object
    };

    connect() {
        this.slimselect = new SlimSelect({
            select: '#placeholder',
            settings: {
                placeholderText: 'Select People',
            },
            ...this.optionsValue
        });
    }

    disconnect() {
        this.slimselect.destroy();
    }
}
