defmodule App.Repo.Migrations.CreateSignInRequests do
  use Ecto.Migration

  def change do
    create table(:sign_in_requests) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :pin, :integer, null: false
      add :sign_in_attempts, :integer, default: 0

      timestamps()
    end

    create index(:sign_in_requests, [:user_id])
  end
end
