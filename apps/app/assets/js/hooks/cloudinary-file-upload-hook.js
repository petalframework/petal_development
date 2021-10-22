import externalFileLoader from "../lib/external-file-loader";

// Cloudinary upload widget docs: https://cloudinary.com/documentation/upload_widget
const CloudinaryFileUploadHook = {
  mounted() {
    let self = this;

    externalFileLoader(
      "https://upload-widget.cloudinary.com/global/all.js",
      "js",
      init
    );

    function init() {
      var allowedFormats = null;
      if (self.el.dataset.fileFormats) {
        allowedFormats = self.el.dataset.fileFormats.split(",");
      }
      let myWidget = cloudinary.createUploadWidget(
        {
          cloudName: self.el.dataset.cloudName,
          uploadPreset: self.el.dataset.uploadPreset,
          showAdvancedOptions: false,
          cropping: false,
          multiple: false,
          sources: ["local"],
          defaultSource: "local",
          clientAllowedFormats: allowedFormats,
          apiKey: self.el.dataset.apiKey,
          uploadSignatureTimestamp: self.el.dataset.uploadSignatureTimestamp,
          uploadSignature: self.el.dataset.uploadSignature,
          styles: {
            palette: {
              window: "#ffffff",
              sourceBg: "#f4f4f5",
              windowBorder: "#9CA3AF",
              tabIcon: "#000000",
              inactiveTabIcon: "#555a5f",
              menuIcons: "#555a5f",
              link: "#3D46F7",
              action: "#339933",
              inProgress: "#3D46F7",
              complete: "#339933",
              error: "#cc0000",
              textDark: "#000000",
              textLight: "#fcfffd",
            },
            fonts: {
              default: null,
              "sans-serif": {
                url: null,
                active: true,
              },
            },
          },
        },
        (error, result) => {
          if (!error && result && result.event === "success") {
            myWidget.close();
            self.pushEvent("file_uploaded", {
              public_id: result.info.public_id,
              field: self.el.dataset.field,
            });
            self.el.remove();
          }
        }
      );

      self.el.addEventListener(
        "click",
        function () {
          myWidget.open();
        },
        false
      );
    }
  },

  // the element has been removed from the page, either by a parent update, or by the parent being removed entirely
  destroyed() {
    const iframes = document.querySelectorAll("[data-test^=uw-iframe]");

    iframes.forEach((iframe) => {
      iframe.parentNode.removeChild(iframe);
    });
  },
};

export default CloudinaryFileUploadHook;
