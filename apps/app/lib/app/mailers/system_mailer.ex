defmodule App.SystemMailer do
  use Bamboo.Phoenix, view: AppWeb.EmailView

  @from_name System.get_env("MAILER_DEFAULT_FROM_NAME") || "Support"
  @from_email System.get_env("MAILER_DEFAULT_FROM_EMAIL") || "support@petalframework.com"

  def template(email) do
    base_email()
    |> to(email)
    |> subject("Template for showing how to do headings, buttons etc in emails")
    |> render(:template)
  end

  def sign_in_pin(email, pin) do
    base_email()
    |> to(email)
    |> subject("Sign in code: #{pin}")
    |> render(:sign_in_pin, %{pin: pin})
  end

  def register_pin(to_email, pin) do
    base_email()
    |> to(to_email)
    |> subject("Register code: #{pin}")
    |> render(:register_pin, %{
      pin: pin,
      preview_text: "#{pin} is your code"
    })
  end

  def reset_password(to_email, url) do
    base_email()
    |> to(to_email)
    |> subject("Reset password")
    |> render(:reset_password, %{url: url})
  end

  def change_email(to_email, url) do
    base_email()
    |> to(to_email)
    |> subject("Update email")
    |> render(:change_email, %{url: url})
  end

  def text_only_email(to_email, subject, body, cc \\ []) do
    new_email()
    |> to(to_email)
    |> from({@from_name, @from_email})
    |> subject(subject)
    |> text_body(body)
    |> cc(cc)
  end

  defp base_email(unsubscribe_url \\ nil) do
    new_email()
    |> from({@from_name, @from_email})
    |> assign(:unsubscribe_url, unsubscribe_url)
    |> put_html_layout({AppWeb.EmailView, "email_layout.html"})
    |> put_text_layout({AppWeb.EmailView, "email_layout.text"})
  end
end
