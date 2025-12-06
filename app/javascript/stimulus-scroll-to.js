import { Controller as i } from "@hotwired/stimulus";
class n extends i {
  initialize() {
    this.scroll = this.scroll.bind(this);
  }
  connect() {
    this.element.addEventListener("click", this.scroll);
  }
  disconnect() {
    this.element.removeEventListener("click", this.scroll);
  }
  scroll(s) {
    s.preventDefault();
    const e = this.element.hash.replace(/^#/, ""), t = document.getElementById(e);
    if (!t) {
      console.warn(`[stimulus-scroll-to] The element with the id: "${e}" does not exist on the page.`);
      return;
    }
    const o = t.getBoundingClientRect().top + window.pageYOffset - this.offset;
    window.scrollTo({
      top: o,
      behavior: this.behavior
    });
  }
  get offset() {
    return this.hasOffsetValue ? this.offsetValue : this.defaultOptions.offset !== void 0 ? this.defaultOptions.offset : 10;
  }
  get behavior() {
    return this.behaviorValue || this.defaultOptions.behavior || "smooth";
  }
  get defaultOptions() {
    return {};
  }
}
n.values = {
  offset: Number,
  behavior: String
};
export {
  n as default
};
