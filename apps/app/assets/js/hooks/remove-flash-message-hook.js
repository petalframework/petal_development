const RemoveFlashMessageHook = {
  mounted() {
    this.el.addEventListener("click", () => {
      this.clearFlashOnServer();
    });

    this.timers = [];

    this.timers.push(
      setTimeout(() => {
        this.startProgressBar();
      }, 50)
    );

    this.timers.push(
      setTimeout(() => {
        this.clearFlashOnServer();
      }, 9900)
    );
  },

  destroyed() {
    this.clearTimers();
  },

  updated() {
    this.startProgressBar();
  },

  startProgressBar() {
    this.el.querySelector(".progress").style.width = "100%";
  },

  clearTimers() {
    this.timers.forEach((timer) => {
      clearTimeout(timer);
    });
  },

  clearFlashOnServer() {
    this.clearTimers();
    this.el.remove();
    this.pushEvent("lv:clear-flash", {}, () => {});
  },
};

export default RemoveFlashMessageHook;
