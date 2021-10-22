defmodule AppWeb.UserSettingsController do
  use AppWeb, :controller

  alias App.Accounts
  alias AppWeb.UserAuth

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "E-mail changed successfully.")
        |> redirect(to: Routes.user_edit_path(conn, :change_email, conn.assigns.current_user))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_edit_path(conn, :change_email, conn.assigns.current_user))
    end
  end

  # Warning: this logs the user out of all sessions (and logs them back in here).
  # Hence, this can't be ported to a live view
  def update_password(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    password = user_params["current_password"]

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_edit_path(conn, :change_password, user))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        conn
        |> put_flash(
          :error,
          "Change password failed \n\n" <> Util.combine_changeset_error_messages(changeset)
        )
        |> redirect(to: Routes.user_edit_path(conn, :change_password, user))
    end
  end

  @doc """
  This can be called by either a moderator or a user
  """
  def delete_user(conn, %{"id" => id}) do
    user_to_delete = Accounts.get_user!(id)
    deleted_email = user_to_delete.email
    deleting_self? = user_to_delete.id == conn.assigns.current_user.id

    authorised? = fn ->
      if deleting_self? || conn.assigns.current_user.is_moderator,
        do: :ok,
        else: :unauthorised
    end

    with :ok <- authorised?.(),
         {:ok, _deleted_user} <- Accounts.delete_user(user_to_delete) do
      App.Logs.log_async("delete_user", %{
        user: conn.assigns.current_user,
        target_user: user_to_delete
      })

      App.MailBluster.delete_by_email(deleted_email)

      if deleting_self? do
        conn
        |> put_flash(:info, "Your account has been deleted.")
        |> UserAuth.log_out_user()
      else
        UserAuth.log_out_another_user(user_to_delete)

        conn
        |> put_flash(:info, "Account deleted.")
        |> redirect(to: "/")
      end
    else
      :unauthorised ->
        conn
        |> put_flash(
          :error,
          "You do not have permission to do this"
        )
        |> redirect(to: "/")

      {:error, :user_is_moderator} ->
        conn
        |> put_flash(
          :error,
          "You can't delete a moderator account."
        )
        |> redirect(to: Routes.user_edit_path(conn, :index, conn.assigns.current_user.id))
    end
  end
end
