defmodule Kommissar.Resources.Commission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kommissar.Resources.{Tag,Client}
  alias Kommissar.Repo

  @attrs [:name, :file_location, :paid, :price, :tags]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "commissions" do
    field :file_location, :string
    field :name, :string
    field :paid, :decimal
    field :price, :decimal
    field :tags, {:array, :string}

    belongs_to :client, Client
    timestamps()
  end

  @doc false
  def changeset(commission, attrs) do
    commission
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> cast_assoc(:client)
  end
end
