// Fetches external JS or CSS files only if they haven't been fetched already
// Useful for hooks that load their own libraries
// eg the Flickity css + js can be loaded like:
// externalFileLoader("https://unpkg.com/flickity@2/dist/flickity.min.css", "css");
// externalFileLoader(
//   "https://unpkg.com/flickity@2/dist/flickity.pkgd.min.js",
//   "js",
//   callbackFunction
// );

function externalFileLoader(filename, filetype, callback) {
  if (filetype == "js") {
    let scriptEl = document.querySelector(`script[src='${filename}']`);

    if (scriptEl === null) {
      // Push the callback into the queue for this file
      putCallbackInQueue(filename, callback);

      // Load the script file
      let el = document.createElement("script");
      el.src = filename;
      el.type = "text/javascript";

      // Run the queued callbacks for this script once done
      el.addEventListener("load", () => {
        processExternalLoaderQueue(filename);
      });

      document.head.appendChild(el);
    } else {
      if (scriptEl.getAttribute("loaded")) {
        // We are good to go - run the callback!
        callback();
      } else {
        // Script has been put on the page but still downloading - add callback to queue
        putCallbackInQueue(filename, callback);
      }
    }
  }

  if (
    filetype == "css" &&
    !document.querySelector(`link[href='${filename}']`)
  ) {
    let el = document.createElement("link");
    el.setAttribute("rel", "stylesheet");
    el.setAttribute("type", "text/css");
    el.setAttribute("href", filename);
    document.head.appendChild(el);
  }
}

function putCallbackInQueue(filename, callback) {
  window.externalLoaderQueue ||= {};
  window.externalLoaderQueue[filename] ||= [];
  window.externalLoaderQueue[filename].push(callback);
}

function processExternalLoaderQueue(filename) {
  // Mark file as loaded
  document
    .querySelector(`script[src='${filename}']`)
    .setAttribute("loaded", true);

  let queue = window.externalLoaderQueue[filename];
  for (var i = 0; i < queue.length; i++) {
    queue[i]();
  }
  queue = [];
}

export default externalFileLoader;
