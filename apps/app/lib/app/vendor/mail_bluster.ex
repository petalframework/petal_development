defmodule App.MailBluster do
  @moduledoc """
  This module allows you to sync your users with MailBluster.
  eg. if user.subscribed_to_marketing_notifications then they should be synced with MailBluster
  This allows you to send mass emails to your subscribed users.
  """
  use Tesla
  require Logger

  plug Tesla.Middleware.BaseUrl, "https://api.mailbluster.com/api"
  plug Tesla.Middleware.Headers, [{"Authorization", System.get_env("MAIL_BLUSTER_API_KEY")}]
  plug Tesla.Middleware.JSON

  def sync_user_async(user, current_mail_bluster_email \\ nil) do
    if System.get_env("MAIL_BLUSTER_API_KEY") do
      App.BackgroundTask.run(fn ->
        sync_user(user, current_mail_bluster_email)
      end)
    else
      Logger.info("MAIL_BLUSTER_API_KEY not set. Not syncing with MailBluster")
    end
  end

  def sync_user(user, current_mail_bluster_email \\ nil) do
    Logger.info("Syncing user id #{user.id} #{user.email} with MailBluster")

    case get_user(user, current_mail_bluster_email) do
      {:ok, response} ->
        case response.status do
          404 ->
            Logger.info("User not in MailBluster.")
            add_user(user)

          200 ->
            Logger.info("User found in MailBluster.")
            update_user(user, current_mail_bluster_email)

          _something_else ->
            Logger.info("mailbluster_api_error")
            Logger.info(response)
        end

      {:error, error} ->
        Logger.info("mailbluster_api_error")
        Logger.error(error)
    end
  end

  def add_user(user) do
    Logger.info("Adding user id #{user.id} #{user.email} to MailBluster")

    case post("/leads", convert_user(user)) do
      {:ok, response} ->
        case response.status do
          422 ->
            Logger.error("Add user failed")
            Logger.error(response.body)

          201 ->
            Logger.info("User added")

          _something_else ->
            Logger.error("mailbluster_api_error")
            Logger.info(response)
        end

      {:error, error} ->
        Logger.info("mailbluster_api_error")
        Logger.error(error)
    end
  end

  def get_user(user, current_mail_bluster_email \\ nil) do
    hashed_email = hash_email(current_mail_bluster_email || user.email)
    get("/leads/#{hashed_email}")
  end

  def update_user(user, current_mail_bluster_email \\ nil) do
    Logger.info("Updating user id #{user.id} #{user.email} in MailBluster")
    hashed_email = hash_email(current_mail_bluster_email || user.email)

    case put("/leads/#{hashed_email}", convert_user(user)) do
      {:ok, response} ->
        case response.status do
          200 ->
            Logger.info("Updated successfully")

          _something_else ->
            Logger.error("mailbluster_api_error")
            Logger.info(response)
        end

      {:error, error} ->
        Logger.info("mailbluster_api_error")
        Logger.error(error)
    end
  end

  def delete_by_email(email) do
    Logger.info("Deleting lead #{email} from MailBluster...")

    case delete("/leads/#{hash_email(email)}") do
      {:ok, response} ->
        case response.status do
          200 ->
            Logger.info("Deleted user from MailBluster")

          404 ->
            Logger.info("User wasn't in MailBluster")

          _something_else ->
            Logger.error("mailbluster_api_error")
            Logger.error(response)
        end

      {:error, error} ->
        Logger.error("mailbluster_api_error")
        Logger.error(error)
    end
  end

  defp hash_email(email), do: :crypto.hash(:md5, email) |> Base.encode16()

  defp convert_user(user),
    do: %{
      firstName: user.name,
      lastName: nil,
      email: user.email,
      timezone: nil,
      ipAddress: anonymise_ip(user.last_signed_in_ip),
      subscribed: user.subscribed_to_marketing_notifications,
      meta: %{
        id: user.id
      }
    }

  defp anonymise_ip(ip) when is_binary(ip) do
    ip_as_array = String.split(ip, ".")

    if length(ip_as_array) == 4 do
      ip_as_array
      |> List.replace_at(-1, 0)
      |> Enum.join(".")
    else
      # probably ipv6
      nil
    end
  end

  defp anonymise_ip(_rest), do: nil
end
