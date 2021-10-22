import externalFileLoader from "../lib/external-file-loader";

const CurrentTimeHook = {
  // the element has been added to the DOM and its server LiveView has finished mounting
  mounted() {
    externalFileLoader(
      "https://unpkg.com/dayjs@1.8.21/dayjs.min.js",
      "js",
      () => {
        loadPlugin(() => {
          init(this.el);
        });
      }
    );
  },

  // the element has been updated in the DOM by the server
  updated() {
    init(this.el);
  },
};

function loadPlugin(callback) {
  externalFileLoader(
    "https://unpkg.com/dayjs@1.8.21/plugin/relativeTime.js",
    "js",
    () => {
      dayjs.extend(window.dayjs_plugin_relativeTime);
      callback();
    }
  );
}

function init(el) {
  let unix = el.dataset.unix;

  // Elixirs Timex does unix in seconds instead of milliseconds.
  // Convert to milliseconds if this is the case
  if (unix.toString().length <= 10) {
    unix = unix * 1000;
  }

  let time = dayjs(unix);

  function updateTime() {
    if (document.body.contains(el)) {
      el.innerText = time.fromNow();
      setTimeout(updateTime, 30000);
    }
  }

  updateTime();
}

export default CurrentTimeHook;
