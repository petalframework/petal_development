/**
 * Auto Resizing for Textarea Elements.
 *
 * This automatically resizes textarea elemens when the content gets
 * longer than the initial height of the element to ease writing for users.
 */
export default function (element) {
  element.style.boxSizing = "border-box";
  var offset = element.offsetHeight - element.clientHeight;
  element.addEventListener("input", function (event) {
    event.target.style.height = "auto";
    event.target.style.height = event.target.scrollHeight + offset + "px";
  });
  element.style.height = element.scrollHeight + offset + "px";
  element.removeAttribute("data-autoresize");
}
