defmodule Kommissar.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string

    timestamps()
  end

  def hash(password) do
    :crypto.hmac(:sha512, salt(), password) |> Base.encode16
  end

  def salt do
    Application.get_env(:kommissar, Kommissar.Accounts)[:salt]
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{} = changeset) do
    password = get_change(changeset, :password, "")

    changeset
    |> put_change(:password_hash, hash(password))
  end
end
