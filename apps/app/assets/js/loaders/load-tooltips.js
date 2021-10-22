import { delegate } from "tippy.js";

document.querySelector("body").onload = function () {
  // Search the body for tooltips and enable them (tippy.js)
  // Create tooltips like this: <div data-tippy-content="My tooltip"></div>
  delegate("body", {
    target: "[data-tippy-content]",
  });
};
