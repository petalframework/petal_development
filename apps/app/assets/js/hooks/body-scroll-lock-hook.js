const BodyScrollLockHook = {
  mounted() {
    window.toggleOverflow();
  },

  destroyed() {
    window.toggleOverflow();
  },
};

export default BodyScrollLockHook;
