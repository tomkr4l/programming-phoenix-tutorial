defmodule Rumbl.Repo.Migrations.CreateAnotations do
  use Ecto.Migration

  def change do
    create table(:anotations) do
      add :body, :text
      add :at, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :video_id, references(:videos, on_delete: :nothing)

      timestamps()
    end

    create index(:anotations, [:user_id])
    create index(:anotations, [:video_id])
  end
end
