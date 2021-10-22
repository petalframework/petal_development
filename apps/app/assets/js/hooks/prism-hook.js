const PrismHook = {
  mounted() {
    this.init();
  },
  updated() {
    this.init();
  },
  init() {
    Prism.highlightAllUnder(this.el);
  },
};

export default PrismHook;
