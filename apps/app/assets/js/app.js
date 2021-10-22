import Alpine from "alpinejs";
import "./loaders/load-phoenix.js";
import "./loaders/load-utils.js";
import "./loaders/load-tooltips.js";

document.querySelector("body").onload = function () {
  Alpine.start();
};
