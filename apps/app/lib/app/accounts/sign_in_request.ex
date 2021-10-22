defmodule App.Accounts.SignInRequest do
  use Ecto.Schema
  import Ecto.Changeset

  alias App.Accounts.User

  schema "sign_in_requests" do
    belongs_to(:user, User)
    field :pin, :integer
    field :sign_in_attempts, :integer, default: 0

    timestamps()
  end

  def create_changeset(%User{id: user_id}) do
    %__MODULE__{}
    |> cast(%{}, [])
    |> change(%{user_id: user_id, pin: Enum.random(100_000..900_000)})
    |> validate_required([:user_id, :pin])
    |> foreign_key_constraint(:user_id, name: :sign_in_requests_user_id_fkey)
  end

  def increment_sign_in_attempts_changeset(sign_in_request) do
    sign_in_request
    |> cast(%{}, [])
    |> change(%{sign_in_attempts: sign_in_request.sign_in_attempts + 1})
  end
end
