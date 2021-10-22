defmodule AppWeb.Css do
  # LAYOUT
  def container_css(), do: "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8"

  # HEADINGS
  def heading_css("h1"),
    do: "text-2xl font-bold leading-7 sm:leading-9 sm:truncate"

  def heading_css("h2"), do: "text-lg leading-6 font-medium"
  def heading_css("h3"), do: "text-gray-700 uppercase font-bold text-xs leading-tight"
  def heading_css("h4"), do: "text-gray-700 font-bold leading-tight"
  def heading_css("h5"), do: "text-gray-500 font-bold leading-tight"

  # FORMS
  def set_border(true), do: "border-red-500 focus:border-red-500"
  def set_border(false), do: "border-gray-300 focus:border-primary-500 focus:ring-primary-500"

  def label_css(), do: "block text-sm dark:text-white font-medium leading-5 text-gray-700 mb-1"

  def checkbox_css(),
    do:
      "w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500 dark:bg-gray-900 dark:border-gray-800"

  def input_css(has_error \\ false),
    do:
      "#{set_border(has_error)} dark:bg-gray-900 dark:text-gray-100 dark:border-gray-800 appearance-none block w-full px-3 py-2 border rounded-md placeholder-gray-400 dark:placeholder-gray-700 focus:outline-none sm:text-sm sm:leading-5 disabled:opacity-50"

  def textarea_css(has_error \\ false),
    do:
      "#{set_border(has_error)} block w-full transition duration-150 focus:ring-primary-500 focus:border-primary-500 border border-gray-300 dark:border-gray-700 rounded-md ease-in-out dark:bg-gray-900 sm:text-sm sm:leading-5 placeholder-gray-400 dark:placeholder-gray-700"

  def select_css(has_error \\ false),
    do:
      "#{set_border(has_error)} mt-1 rounded-md dark:border-gray-800 block dark:bg-gray-900 w-full pl-3 pr-10 py-2 text-base leading-6 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm sm:leading-5"

  def error_tag_css(), do: "text-red-500 text-xs italic mt-1"

  # TABLES
  def th_class(),
    do:
      "px-6 py-3 text-xs font-medium leading-4 tracking-wider text-left text-gray-500 uppercase bg-gray-50"

  def td_class(), do: "px-6 py-4 text-sm font-medium leading-5 text-gray-500 whitespace-no-wrap"

  def td_class("bold"),
    do: "px-6 py-4 text-sm font-medium leading-5 text-gray-900 whitespace-no-wrap"

  @doc """
  Create a button - optionally pass in the color and size

  Examples (in your HTML templates):
  <div class="<%= container_css() %> pt-10">

  <%= link "Get Access",
    to: "#",
    class: button_css(color: "yellow-light", size: "xl") <> " w-full"
  %>
  """
  def button_css(opts \\ []) do
    color = opts[:color] || "primary"
    size = opts[:size] || "md"

    color_css =
      case color do
        "primary" ->
          "border-transparent text-white bg-primary-600 active:bg-primary-700 hover:bg-primary-500 focus:border-primary-700 focus:shadow-outline-blue"

        "secondary" ->
          "border-transparent text-white bg-secondary-600 active:bg-secondary-700 hover:bg-secondary-500 focus:border-secondary-700 focus:shadow-outline-blue"

        "white" ->
          "border-gray-300 hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue active:bg-gray-50 active:text-gray-800"

        "green" ->
          "border-transparent text-white bg-green-600 active:bg-green-700 hover:bg-green-500 focus:border-green-700 focus:shadow-outline-green"

        "gray" ->
          "border-transparent text-white bg-gray-600 active:bg-gray-700 hover:bg-gray-500 focus:border-gray-700 focus:shadow-outline-gray"

        "gray-light" ->
          "border-transparent text-gray-800 bg-gray-300 active:bg-gray-400 hover:bg-gray-400 focus:border-gray-400 focus:shadow-outline-gray"

        "blue" ->
          "border-transparent text-white bg-blue-600 active:bg-blue-700 hover:bg-blue-500 focus:border-blue-700 focus:shadow-outline-blue"

        "pink" ->
          "border-transparent text-white bg-pink-600 active:bg-pink-700 hover:bg-pink-500 focus:border-pink-700 focus:shadow-outline-pink"

        "purple" ->
          "border-transparent text-white bg-purple-600 active:bg-purple-700 hover:bg-purple-500 focus:border-purple-700 focus:shadow-outline-purple"

        "orange" ->
          "border-transparent text-white bg-orange-600 active:bg-orange-700 hover:bg-orange-500 focus:border-orange-700 focus:shadow-outline-orange"

        "red" ->
          "border-transparent text-white bg-red-600 active:bg-red-700 hover:bg-red-500 focus:border-red-700 focus:shadow-outline-red"

        "yellow-light" ->
          "border-transparent text-gray-900 bg-yellow-300 active:bg-yellow-200 hover:bg-yellow-200 focus:border-yellow-200 focus:shadow-outline-yellow"

        "deep-red" ->
          "border-transparent text-white bg-red-800 active:bg-red-900 hover:bg-red-700 focus:border-red-900 focus:shadow-outline-red"
      end

    size_css =
      case size do
        "xs" -> "text-xs leading-4 px-2.5 py-1.5 "
        "sm" -> "text-sm leading-4 px-3 py-2"
        "md" -> "text-sm leading-5 px-4 py-2"
        "lg" -> "text-base leading-6 px-4 py-2"
        "xl" -> "text-base leading-6 px-6 py-3"
      end

    """
      #{color_css}
      #{size_css} font-medium
      disabled:opacity-50
      shadow-sm
      rounded-md
      inline-flex items-center justify-center
      border
      focus:outline-none
      transition duration-150 ease-in-out
    """
  end

  @doc """
  Example
  <%= link "Sign in",
    to: Routes.auth_password_auth_path(@conn, :sign_in),
    class: link_css(color: "blue")
  %>
  """
  def link_css(opts \\ []) do
    color = opts[:color] || "primary"

    base_css =
      "cursor-pointer font-medium transition duration-150 ease-in-out focus:outline-none focus:underline"

    color_css =
      case color do
        "primary" ->
          "text-primary-600 dark:text-primary-400 dark:hover:text-primary-300 hover:text-primary-400"

        "blue" ->
          "text-blue-600 dark:text-gray-400 dark:hover:text-gray-300 hover:text-blue-400"
      end

    "#{base_css} #{color_css}"
  end
end
