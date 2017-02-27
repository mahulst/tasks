defmodule Tasks.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:boards, [:user_id])

  end
end
