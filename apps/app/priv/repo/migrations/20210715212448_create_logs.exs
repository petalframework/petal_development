defmodule App.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :action, :string
      add :user_type, :string, default: "user"
      add :user_id, references(:users, on_delete: :nothing)
      add :target_user_id, references(:users, on_delete: :nothing)
      add :metadata, :map

      timestamps()
    end

    create index(:logs, [:action])
    create index(:logs, [:user_type])
    create index(:logs, [:user_id])
    create index(:logs, [:target_user_id])
  end
end
