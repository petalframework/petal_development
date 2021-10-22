defmodule AppWeb.Petal.Components.DarkThemeSwitch do
  use AppWeb, :surface_component

  def render(assigns) do
    ~F"""
    <div class="bg-pink-400 theme-switch-wrapper dark:bg-gray-500">
      <input type="checkbox" class="theme-switch" id="theme-switch" phx-hook="DarkModeHook">
      <div class="switch-ui">
        <svg class="moon" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"><path d="M8 16a7.947 7.947 0 003.5-.815C8.838 13.886 7 11.161 7 8S8.838 2.114 11.5.815A7.947 7.947 0 008 0a8 8 0 000 16zM14 3a2 2 0 01-2 2 2 2 0 012 2 2 2 0 012-2 2 2 0 01-2-2z" /><path d="M10 6a2 2 0 01-2 2 2 2 0 012 2 2 2 0 012-2 2 2 0 01-2-2zM13 13a2 2 0 012-2 2 2 0 01-2-2 2 2 0 01-2 2 2 2 0 012 2z" /></svg>
        <svg class="sun" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"><circle cx="8.5" cy="7.5" r="4.5" /><path d="M8 0h1v2H8zM8 13h1v2H8zM14 7h2v1h-2zM1 7h2v1H1zM12.035 11.743l.707-.707 1.414 1.414-.707.707zM2.843 2.55l.707-.707 1.415 1.414-.707.707zM2.843 12.45l1.414-1.415.707.707-1.414 1.415zM12.035 3.257l1.414-1.414.708.707-1.415 1.415z" /></svg>
      </div>
    </div>
    """
  end
end
