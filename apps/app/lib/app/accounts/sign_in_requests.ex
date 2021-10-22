defmodule App.Accounts.SignInRequests do
  alias App.Repo
  alias App.Accounts.User
  alias App.Accounts.SignInRequest
  alias Ecto.Multi
  import Ecto.Query

  def create_sign_in_request(%User{} = user) do
    Multi.new()
    |> Multi.delete_all(:delete_sign_in_requests, Ecto.assoc(user, :sign_in_request))
    |> Multi.insert(:sign_in_request, fn _ -> SignInRequest.create_changeset(user) end)
    |> Repo.transaction()
  end

  @doc """
  Finds a user's SignInRequest that did not expire yet.

  Returns:
  1. {:ok, true} if the pin was found and did not expire.
  2. {:ok, false} if the pin was found but expired.
  3. {:error, :not_found} if the pin wasn't found at all.
  """
  def find_sign_in_request(%User{id: user_id}, pin) do
    from(
      l in SignInRequest,
      where: l.user_id == ^user_id
    )
    |> Repo.one()
    |> determine_pin_validity(pin)
  end

  defp determine_pin_validity(nil, _pin), do: {:error, :not_found}

  defp determine_pin_validity(
         %SignInRequest{
           updated_at: sign_in_request_created_at,
           sign_in_attempts: sign_in_attempts
         } = sign_in_request,
         pin
       ) do
    expired? =
      Timex.diff(Timex.now(), sign_in_request_created_at, :minutes) >=
        Application.get_env(:app, :sign_in_request_expires_in)

    sign_in_request_pin_as_string = Integer.to_string(sign_in_request.pin)

    cond do
      expired? ->
        {:error, :expired}

      sign_in_attempts >= 5 ->
        {:error, :too_many_incorrect_attempts}

      sign_in_request_pin_as_string != pin ->
        {:error, :incorrect_pin}

      sign_in_request_pin_as_string == pin ->
        {:ok, sign_in_request}
    end
  end

  def increment_sign_in_attempts(nil), do: {:ok, nil}

  def increment_sign_in_attempts(user) do
    case Repo.preload(user, :sign_in_request).sign_in_request do
      nil ->
        {:ok, nil}

      sign_in_request ->
        SignInRequest.increment_sign_in_attempts_changeset(sign_in_request)
        |> Repo.update()
    end
  end
end
