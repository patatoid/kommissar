defmodule Kommissar.Resources.Client do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kommissar.Resources.{Tag,Commission}
  alias Kommissar.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clients" do
    field :comments, :string
    field :credit, :decimal
    field :email, :string
    field :late_payer, :boolean, default: false
    field :name, :string
    field :premium, :boolean, default: false
    field :social_media, :map

    has_many :commission, Commission
    many_to_many :tags, Tag, join_through: "tag_relationships", join_keys: [client_id: :id, tag_id: :client_id]

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :email, :social_media, :credit, :premium, :late_payer, :comments])
    |> validate_required([:name, :email, :social_media, :credit, :tags, :premium, :late_payer, :comments])
    |> validate_format(:email, ~r/@/)
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
