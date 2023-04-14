import { Controller } from '@hotwired/stimulus';

export default class extends Controller {

    connect() {
        const url=window.location.href;
        if (url.includes("#")) {
            const target = document.querySelector(url.substring(url.indexOf("#")))
            const elementPosition = target.getBoundingClientRect().top + window.scrollY;
            window.scrollTo({
                top: elementPosition,
                left: 0,
                behavior: 'smooth'
            })
        }
    }

    scroll(event) {
        event.preventDefault();
        const target = document.querySelector(event.currentTarget.dataset.scrollToTarget)
        const elementPosition = target.getBoundingClientRect().top + window.scrollY;
        window.scrollTo({
            top: elementPosition,
            left: 0,
            behavior: 'smooth'
        })
    }
}


