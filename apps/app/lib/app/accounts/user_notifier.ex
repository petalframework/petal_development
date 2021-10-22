defmodule App.Accounts.UserNotifier do
  alias App.{SystemMailer, Mailer}

  @doc """
  Passwordless mode only. Deliver a pin code to sign in.
  """
  def deliver_sign_in_pin_instructions(user, pin) do
    SystemMailer.sign_in_pin(user.email, pin)
    |> Mailer.deliver_later()
  end

  @doc """
  Deliver instructions to confirm email while registering
  """
  def deliver_register_pin_instructions(email, pin) do
    SystemMailer.register_pin(email, pin)
    |> Mailer.deliver_later()
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    SystemMailer.register_pin(user.email, url)
    |> Mailer.deliver_later()
  end

  @doc """
  Deliver instructions to reset password account.
  """
  def deliver_reset_password_instructions(user, url) do
    SystemMailer.reset_password(user.email, url)
    |> Mailer.deliver_later()
  end

  @doc """
  Deliver instructions to update your e-mail.
  """
  def deliver_update_email_instructions(user, url) do
    SystemMailer.change_email(user.email, url)
    |> Mailer.deliver_later()
  end

  @doc """
  When someone fills out the contact form, send it to support
  """
  def deliver_contact_form(fields, from_user \\ nil) do
    from =
      if from_user do
        "Sent from #{from_user.name} - #{from_user.email} (ID: #{from_user.id})"
      else
        ""
      end

    body =
      from <>
        """
        #{Enum.map(fields, fn {k, v} -> "#{k}: #{if Util.present?(v), do: v, else: "Not answered"} \n\n" end)}
        """

    SystemMailer.text_only_email(
      System.get_env("SUPPORT_EMAIL"),
      "New contact form submission!",
      body
    )
    |> Mailer.deliver_later()
  end
end
