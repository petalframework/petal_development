import autosize from "../lib/textarea-auto-resize";

const ResizeTextareaHook = {
  mounted() {
    autosize(this.el);
  },
  updated() {
    autosize(this.el);
  },
};

export default ResizeTextareaHook;
