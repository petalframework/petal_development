defmodule AppWeb.Petal.Components.DateTimeLocal do
  use AppWeb, :surface_component

  # https://day.js.org/docs/en/display/format
  # Here is a cheatsheet for formatting a date:
  # h:mm A	8:02 PM
  # h:mm:ss A	8:02:18 PM
  # MM/DD/YYYY	08/16/2018
  # MMMM D, YYYY	August 16, 2018
  # MMMM D, YYYY h:mm A	August 16, 2018 8:02 PM
  # dddd, MMMM D, YYYY h:mm A	Thursday, August 16, 2018 8:02 PM
  # M/D/YYYY	8/16/2018
  # MMM D, YYYY	Aug 16, 2018
  # MMM D, YYYY h:mm A	Aug 16, 2018 8:02 PM
  # ddd, MMM D, YYYY h:mm A	Thu, Aug 16, 2018 8:02 PM

  prop(unix, :any)
  prop(date_time, :any)
  prop(format, :string)
  prop(class, :css_class)

  def get_unix(%{date_time: nil, unix: nil}), do: 0
  def get_unix(%{date_time: nil, unix: unix}), do: unix
  def get_unix(%{date_time: date_time, unix: nil}), do: Timex.to_unix(date_time)
  def get_unix(%{date_time: _dt, unix: unix}), do: unix

  def render(assigns) do
    ~F"""
    <span
      :if={get_unix(assigns) != nil}
      x-data={"{time: dayjs(#{get_unix(assigns)} * 1000)}"}
      x-text={"#{if @format, do: "time.format('#{@format}')", else: "time.fromNow()"}"}
      class={@class}
    />
    """
  end
end
