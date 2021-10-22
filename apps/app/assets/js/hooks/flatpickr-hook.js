import flatpickr from "flatpickr";

const FlatpickrHook = {
  mounted() {
    this.init();
  },
  destroyed() {
    if (this.instance) this.instance.destroy();
  },
  updated() {
    this.init();
  },
  init() {
    if (this.instance) this.instance.destroy();
    let opts = JSON.parse(this.el.dataset.flatpickrOpts);
    this.instance = flatpickr(this.el, opts);
  },
};

export default FlatpickrHook;
