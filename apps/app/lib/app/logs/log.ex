defmodule App.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset
  use QueryBuilder

  @user_type_options ["user", "moderator"]
  @action_options [
    "update_profile",
    "register",
    "sign_in",
    "pin_code_sent",
    "pin_code_too_many_incorrect_attempts",
    "logout",
    "confirm_new_email",
    "delete_user"
  ]

  schema "logs" do
    field :action, :string
    field :user_type, :string, default: "user"

    belongs_to :user, App.Accounts.User
    belongs_to :target_user, App.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [
      :action,
      :user_type,
      :user_id,
      :target_user_id,
      :inserted_at
    ])
    |> validate_required([
      :action,
      :user_type,
      :user_id
    ])
    |> validate_inclusion(:action, @action_options)
    |> validate_inclusion(:user_type, @user_type_options)
  end

  def action_options, do: @action_options
end
