defmodule Kommissar.Repo.Migrations.CreateCommissions do
  use Ecto.Migration

  def change do
    create table(:commissions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :tags, {:array, :string}
      add :file_location, :string
      add :paid, :decimal
      add :price, :decimal

      add :client_id, references(:clients, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:commissions, [:client_id])
    create index(:commissions, [:tags])
  end
end
