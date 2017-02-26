defmodule Tasks.Repo.Migrations.CreateAap do
  use Ecto.Migration

  def change do
    create table(:apen) do
      add :name, :string

      timestamps()
    end

  end
end
