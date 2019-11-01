defmodule Kommissar.Resources.Commission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kommissar.Resources.{Tag,Client}
  alias Kommissar.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "commissions" do
    field :file_location, :string
    field :name, :string
    field :paid, :decimal
    field :price, :decimal

    belongs_to :client, Client
    many_to_many :tags, Tag, join_through: "tag_relationships", join_keys: [commission_id: :id, tag_id: :commission_id]

    timestamps()
  end

  @doc false
  def changeset(commission, attrs) do
    commission
    |> cast(attrs, [:name, :file_location, :paid, :price])
    |> validate_required([:name, :tags, :file_location, :paid, :price])
    |> put_assoc(:tags, parse_tags(attrs))
  end

  defp parse_tags(attrs)  do
    (attrs["tags"] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_tag/1)
  end

  defp get_or_insert_tag(name) do
    Repo.get_by(MyApp.Tag, name: name) ||
      Repo.insert!(MyApp.Tag, %Tag{name: name})
  end
end
