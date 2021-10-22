defmodule App.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :slug, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :confirmed_at, :naive_datetime
    field :is_moderator, :boolean
    field :avatar_cloudinary_id, :string
    field :avatar, :any, virtual: true
    field :delete_avatar, :boolean, virtual: true
    field :last_signed_in_ip, :string
    field :last_signed_in_datetime, :utc_datetime
    field :subscribed_to_marketing_notifications, :boolean
    field :is_suspended, :boolean
    field :is_deleted, :boolean

    timestamps()
  end

  def base_validations(changeset) do
    changeset
    |> update_change(:name, &Util.trim/1)
    |> validate_length(:name, min: 2, max: 50)
    |> email_validations()
  end

  def email_validations(changeset) do
    changeset
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
    |> validate_email()
  end

  # --- Changesets ---

  @doc """
  A user changeset for registration.

  It is important to validate the length of both e-mail and password.
  Otherwise databases may truncate the e-mail without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name])
    |> base_validations()
    |> validate_required([:email])
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, App.Repo)
    |> unique_constraint(:email)
    |> validate_email()
    |> validate_password()
  end

  def passwordless_registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name])
    |> base_validations()
    |> validate_required([:email])
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, App.Repo)
    |> unique_constraint(:email)
    |> validate_email()
  end

  @doc """
  Never expose this changeset to the user. Moderators only
  """
  def toggle_moderator_changeset(user, attrs), do: cast(user, attrs, [:is_moderator])

  def moderator_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :email,
      :avatar_cloudinary_id,
      :last_signed_in_ip,
      :last_signed_in_datetime,
      :subscribed_to_marketing_notifications,
      :is_suspended,
      :is_deleted
    ])
    |> base_validations()
  end

  def profile_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :password,
      :name,
      :avatar_cloudinary_id,
      :subscribed_to_marketing_notifications
    ])
    |> base_validations()
  end

  def email_only_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required(:email)
    |> email_validations()
  end

  def last_signed_in_changeset(user, ip) do
    user
    |> cast(%{}, [])
    |> change(%{
      last_signed_in_ip: ip,
      last_signed_in_datetime: DateTime.utc_now() |> DateTime.truncate(:second)
    })
  end

  # For development only. Mainly for UserSeeder. We use fake emails in dev that wouldn't pass normal validation
  def dev_registration_changeset(user, attrs) do
    cast(user, attrs, [:email, :password, :name])
    |> validate_password()
  end

  def validate_email(changeset) do
    validate_change(changeset, :email, fn :email, email ->
      if Util.email_valid?(email), do: [], else: [email: "is invalid"]
    end)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 80)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> prepare_changes(&hash_password/1)
  end

  @doc """
  A user changeset for changing the e-mail.

  It requires the e-mail to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.
  """
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password()
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%App.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  @doc """
  User notifications (emails) details can be put here.
  If a user receives a notification, they need a way of easily unsubbing from a particular kind of notification.
  Eg. Unsub from "subscribed_to_marketing_notifications". Or unsub from "setting_notification_new_reply_to_my_comment"
  """
  def notification_fields do
    [
      %{
        field: :subscribed_to_marketing_notifications,
        label: "Subscribe to product updates",
        description: "Get email updates about this product",
        unsub_description: "You will no longer get updates about Petal"
      }
      # Example of a different type of notification:
      # %{
      #   field: :setting_notification_new_reply_to_my_comment,
      #   label: "Replies",
      #   description: "Get notified when someone replies to your comment",
      #   unsub_description: "You will no longer get notified when someone replies to your comment"
      # }
    ]
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
    |> delete_change(:password)
  end
end
