defmodule App.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :name, :string
      add :slug, :string
      add :avatar_cloudinary_id, :string
      add :is_moderator, :boolean, null: false, default: false
      add :email, :citext, null: false
      add :hashed_password, :string
      add :confirmed_at, :naive_datetime
      add :last_signed_in_ip, :string
      add :last_signed_in_datetime, :utc_datetime
      add :subscribed_to_marketing_notifications, :boolean, null: false, default: true
      add :is_suspended, :boolean, null: false, default: false
      add :is_deleted, :boolean, null: false, default: false
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
