defmodule Kommissar.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :social_media, :map
      add :credit, :decimal
      add :tags, {:array, :string}
      add :premium, :boolean, default: false, null: false
      add :late_payer, :boolean, default: false, null: false
      add :comments, :text

      timestamps()
    end

    create index(:clients, [:tags])
  end
end
