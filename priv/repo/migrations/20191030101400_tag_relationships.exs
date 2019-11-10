defmodule Kommissar.Repo.Migrations.TagRelationships do
  use Ecto.Migration

  def change do
    create table(:tag_relationships, primary_key: false) do
      add :client_id, references(:clients, type: :uuid)
      add :commission_id, references(:commissions, type: :uuid)
      add :tag_id, references(:tags, type: :uuid)
    end
  end
end
