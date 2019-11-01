defmodule Kommissar.ResourcesTest do
  use Kommissar.DataCase

  alias Kommissar.Resources

  describe "clients" do
    alias Kommissar.Resources.Client

    @valid_attrs %{comments: "some comments", credit: "120.5", email: "some@email", late_payer: true, name: "some name", premium: true, social_media: %{}, tags: ["kawaii", "admech", "btk"]}
    @update_attrs %{comments: "some updated comments", credit: "456.7", email: "some@updatedemail", late_payer: false, name: "some updated name", premium: false, social_media: %{}, tags: ["kawaii", "btk"]}
    @invalid_attrs %{comments: nil, credit: nil, email: nil, late_payer: nil, name: nil, premium: nil, social_media: nil, tags: []}

    def client_fixture(attrs \\ %{}) do
      {:ok, client} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Resources.create_client()

      client
    end

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      assert Resources.list_clients() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Resources.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      assert {:ok, %Client{} = client} = Resources.create_client(@valid_attrs)
      assert client.comments == "some comments"
      assert client.credit == Decimal.new("120.5")
      assert client.email == "some@email"
      assert client.late_payer == true
      assert client.name == "some name"
      assert client.premium == true
      assert client.social_media == %{}
      assert client.tags == []
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      assert {:ok, %Client{} = client} = Resources.update_client(client, @update_attrs)
      assert client.comments == "some updated comments"
      assert client.credit == Decimal.new("456.7")
      assert client.email == "some@updatedemail"
      assert client.late_payer == false
      assert client.name == "some updated name"
      assert client.premium == false
      assert client.social_media == %{}
      assert client.tags == []
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_client(client, @invalid_attrs)
      assert client == Resources.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Resources.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Resources.change_client(client)
    end
  end

  describe "commissions" do
    alias Kommissar.Resources.Commission

    @valid_attrs %{file_location: "some file_location", name: "some name", paid: "120.5", price: "120.5", tags: []}
    @update_attrs %{file_location: "some updated file_location", name: "some updated name", paid: "456.7", price: "456.7", tags: []}
    @invalid_attrs %{file_location: nil, name: nil, paid: nil, price: nil, tags: nil}

    def commission_fixture(attrs \\ %{}) do
      {:ok, commission} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Resources.create_commission()

      commission
    end

    test "list_commissions/0 returns all commissions" do
      commission = commission_fixture()
      assert Resources.list_commissions() == [commission]
    end

    test "get_commission!/1 returns the commission with given id" do
      commission = commission_fixture()
      assert Resources.get_commission!(commission.id) == commission
    end

    test "create_commission/1 with valid data creates a commission" do
      assert {:ok, %Commission{} = commission} = Resources.create_commission(@valid_attrs)
      assert commission.file_location == "some file_location"
      assert commission.name == "some name"
      assert commission.paid == Decimal.new("120.5")
      assert commission.price == Decimal.new("120.5")
      assert commission.tags == []
    end

    test "create_commission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_commission(@invalid_attrs)
    end

    test "update_commission/2 with valid data updates the commission" do
      commission = commission_fixture()
      assert {:ok, %Commission{} = commission} = Resources.update_commission(commission, @update_attrs)
      assert commission.file_location == "some updated file_location"
      assert commission.name == "some updated name"
      assert commission.paid == Decimal.new("456.7")
      assert commission.price == Decimal.new("456.7")
      assert commission.tags == []
    end

    test "update_commission/2 with invalid data returns error changeset" do
      commission = commission_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_commission(commission, @invalid_attrs)
      assert commission == Resources.get_commission!(commission.id)
    end

    test "delete_commission/1 deletes the commission" do
      commission = commission_fixture()
      assert {:ok, %Commission{}} = Resources.delete_commission(commission)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_commission!(commission.id) end
    end

    test "change_commission/1 returns a commission changeset" do
      commission = commission_fixture()
      assert %Ecto.Changeset{} = Resources.change_commission(commission)
    end
  end
end
