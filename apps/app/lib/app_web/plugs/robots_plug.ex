defmodule AppWeb.RobotsPlug do
  @moduledoc """
    A robots.txt Plug
  """

  import Plug.Conn, only: [put_resp_content_type: 2, send_resp: 3, halt: 1]

  @robots_path "/robots.txt"
  @content_type "text/plain"

  def init(opts), do: opts

  def call(conn, opts) do
    case conn.request_path do
      @robots_path -> resp_robots(conn, opts)
      _ -> conn
    end
  end

  def resp_robots(conn, _opts) do
    opts =
      if System.get_env("ALLOW_ROBOTS") == "true" do
        :allow
      else
        :deny
      end

    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(:ok, resp_body(opts))
    |> halt()
  end

  def resp_body(:allow) do
    """
    User-agent: *
    Allow: /
    """
  end

  def resp_body(:deny) do
    """
    User-agent: *
    Disallow: /
    """
  end
end
