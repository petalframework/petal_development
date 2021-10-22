// https://tailwindcss.com/docs/customizing-colors
const colors = require("tailwindcss/colors");
const defaultTheme = require("tailwindcss/defaultTheme");

const denim = {
  50: "#f5f9fa",
  100: "#e0f0fb",
  200: "#bcdef7",
  300: "#8dbdea",
  400: "#5d97da",
  500: "#4775cb",
  600: "#3b59b5",
  700: "#2f4392",
  800: "#212d68",
  900: "#131c42",
};

const orchid = {
  50: "#fff7fd",
  100: "#fbe0f7",
  200: "#f9bdf1",
  300: "#ec94ed",
  400: "#cc6edc",
  500: "#a753c3",
  600: "#8640a7",
  700: "#66308d",
  800: "#492273",
  900: "#301057",
};

module.exports = {
  mode: "jit",
  purge: [
    "../lib/**/*.html.{eex, leex}",
    "../lib/**/*.sface",
    "../lib/**/views/**/*.ex",
    "../lib/**/live/**/*.ex",
    "./js/**/*.js",
    "../lib/app_web.ex",
    "../config/*.exs",
  ],
  darkMode: "class",
  variants: {
    extend: {
      typography: ["dark"],
    },
  },
  theme: {
    extend: {
      colors: {
        primary: orchid,
        secondary: denim,
      },
      typography(theme) {
        return {
          DEFAULT: {
            css: {
              h2: {
                paddingBottom: "3px",
                borderBottomWidth: "1px",
                borderStyle: "solid",
                borderBottomColor: theme("colors.gray.200"),
              },
            },
          },
          dark: {
            css: {
              color: theme("colors.gray.300"),
              '[class~="lead"]': { color: theme("colors.gray.400") },
              a: { color: theme("colors.gray.100") },
              strong: { color: theme("colors.gray.100") },
              "ul > li::before": { backgroundColor: theme("colors.gray.700") },
              hr: { borderColor: theme("colors.gray.800") },
              blockquote: {
                color: theme("colors.gray.100"),
                borderLeftColor: theme("colors.gray.800"),
              },
              h1: { color: theme("colors.gray.100") },
              h2: { color: theme("colors.gray.100") },
              h3: { color: theme("colors.gray.100") },
              h4: { color: theme("colors.gray.100") },
              code: { color: theme("colors.gray.100") },
              "a code": { color: theme("colors.gray.100") },
              pre: {
                color: theme("colors.gray.200"),
                backgroundColor: theme("colors.gray.800"),
              },
              thead: {
                color: theme("colors.gray.100"),
                borderBottomColor: theme("colors.gray.700"),
              },
              "tbody tr": { borderBottomColor: theme("colors.gray.800") },
            },
          },
        };
      },
    },
  },
  plugins: [require("@tailwindcss/forms"), require("@tailwindcss/typography")],
};
