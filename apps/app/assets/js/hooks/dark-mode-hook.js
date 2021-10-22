import gsap from "gsap";

const DarkModeHook = {
  mounted() {
    const themeSwitch = this.el;
    const mode = DarkModeHook.getInitialColorMode();

    if (mode === "dark") {
      themeSwitch.checked = true;
      DarkModeHook.setMode("dark");
    }

    themeSwitch.addEventListener("change", () => {
      // prevent elements to transition during theme transition
      const transitionEls = document.querySelectorAll(".w-transition");
      if (transitionEls) {
        gsap.utils.toArray(transitionEls).forEach((el) => {
          el.classList.remove("w-transition");
          setTimeout(() => {
            el.classList.add("w-transition");
          }, 300);
        });
      }

      DarkModeHook.setMode(themeSwitch.checked ? "dark" : "light");
    });
  },

  getInitialColorMode() {
    const persistedColorPreference = window.localStorage.getItem("dark-mode");
    const hasPersistedPreference = typeof persistedColorPreference === "string";
    if (hasPersistedPreference) {
      return persistedColorPreference;
    }
    const mql = window.matchMedia("(prefers-color-scheme: dark)");
    const hasMediaQueryPreference = typeof mql.matches === "boolean";
    if (hasMediaQueryPreference) {
      return mql.matches ? "dark" : "light";
    }
    return "light";
  },

  setMode(mode) {
    if (mode === "dark") {
      document.documentElement.classList.add("dark");
      localStorage.setItem("dark-mode", "dark");
    } else {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("dark-mode", "light");
    }
  },
};

export default DarkModeHook;
