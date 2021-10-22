import truncate from "truncate";
import TextareaAutoResize from "../lib/textarea-auto-resize.js";

// Used in AppWeb.Petal.Components.UserContent
window.truncate = truncate;

// AppWeb.Petal.Components.FormField
window.TextareaAutoResize = TextareaAutoResize;

// This is used by modals. When a modal is open we don't want the user to be able to scroll the body in the background
window.toggleOverflow = function () {
  document.querySelector("body").classList.toggle("overflow-hidden");
};

// Can be used when submitting a form to disable the button
// TODO: integrate these into a hook
window.disableButton = (el) => {
  el.disabled = true;
  el.classList.add("opacity-50", "cursor-not-allowed");
};

window.enableButton = (el) => {
  el.disabled = false;
  el.classList.remove("opacity-50", "cursor-not-allowed");
};
