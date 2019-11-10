defmodule Kommissar.Resources.Client do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kommissar.Resources.{Tag,Commission}
  alias Kommissar.Repo

  @attrs [:name, :email, :social_media, :credit, :premium, :late_payer, :comments, :tags]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "clients" do
    field :comments, :string
    field :credit, :decimal
    field :email, :string
    field :late_payer, :boolean, default: false
    field :name, :string
    field :premium, :boolean, default: false
    field :social_media, :map
    field :tags, {:array, :string}

    has_many :commissions, Commission
    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> validate_format(:email, ~r/@/)
  end
end
