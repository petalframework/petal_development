import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import Hooks from "../hooks";
import topbar from "topbar";
import Alpine from "alpinejs";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        Alpine.clone(from, to);
      }
    },
  },
  params: { _csrf_token: csrfToken },
});

// Connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// Caution: only run these in the browser console, incase you uncomment here and check in the code!
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

// Show a progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());
