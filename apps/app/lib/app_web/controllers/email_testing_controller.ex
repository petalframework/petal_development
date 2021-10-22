defmodule AppWeb.EmailTestingController do
  use AppWeb, :controller
  alias App.{Mailer}

  # How to add a new email notification:
  # 1. create new function in SystemMailer
  # 2. create new function in UserNotifier
  # 3. in this file add to @email_templates
  # 4. in this file add a new generate_email function

  @email_templates [
    "template",
    "register_pin",
    "reset_password",
    "change_email"
  ]

  def index(conn, _params) do
    redirect(conn, to: Routes.email_testing_path(conn, :preview, "template"))
  end

  def preview(conn, %{"email_name" => email_name}) do
    conn
    |> put_root_layout({AppWeb.LayoutView, "empty.html"})
    |> render(
      "index.html",
      %{
        email: generate_email(email_name, conn.assigns.current_user),
        email_name: email_name,
        email_options: @email_templates,
        iframe_url: Routes.email_testing_url(conn, :show_html, email_name)
      }
    )
  end

  def send_test_email(conn, %{"email_name" => email_name}) do
    if Util.email_valid?(conn.assigns.current_user.email) do
      generate_email(email_name, conn.assigns.current_user)
      |> Mailer.deliver_later(config: %{adapter: Bamboo.SesAdapter})

      conn
      |> put_flash(:info, "Email sent")
      |> redirect(to: Routes.email_testing_path(conn, :preview, email_name))
    else
      conn
      |> put_flash(:error, "Email invalid")
      |> redirect(to: Routes.email_testing_path(conn, :preview, email_name))
    end
  end

  def show_html(conn, %{"email_name" => email_name}) do
    email = generate_email(email_name, conn.assigns.current_user)

    conn
    |> put_layout(false)
    |> html(email.html_body)
  end

  defp generate_email("template", current_user) do
    App.SystemMailer.template(current_user.email)
  end

  defp generate_email("register_pin", current_user) do
    App.SystemMailer.register_pin(current_user.email, "338913")
  end

  defp generate_email("reset_password", current_user) do
    App.SystemMailer.reset_password(current_user.email, "#")
  end

  defp generate_email("change_email", current_user) do
    App.SystemMailer.change_email(current_user.email, "#")
  end
end
