defmodule Rumbl.AccountsTest do
  use Rumbl.DataCase

  alias Rumbl.Accounts

  describe "credentials" do
    alias Rumbl.Accounts.Credentials

    @valid_attrs %{email: "some email", password_hash: "some password_hash"}
    @update_attrs %{email: "some updated email", password_hash: "some updated password_hash"}
    @invalid_attrs %{email: nil, password_hash: nil}

    def credentials_fixture(attrs \\ %{}) do
      {:ok, credentials} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_credentials()

      credentials
    end

    test "list_credentials/0 returns all credentials" do
      credentials = credentials_fixture()
      assert Accounts.list_credentials() == [credentials]
    end

    test "get_credentials!/1 returns the credentials with given id" do
      credentials = credentials_fixture()
      assert Accounts.get_credentials!(credentials.id) == credentials
    end

    test "create_credentials/1 with valid data creates a credentials" do
      assert {:ok, %Credentials{} = credentials} = Accounts.create_credentials(@valid_attrs)
      assert credentials.email == "some email"
      assert credentials.password_hash == "some password_hash"
    end

    test "create_credentials/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_credentials(@invalid_attrs)
    end

    test "update_credentials/2 with valid data updates the credentials" do
      credentials = credentials_fixture()
      assert {:ok, %Credentials{} = credentials} = Accounts.update_credentials(credentials, @update_attrs)
      assert credentials.email == "some updated email"
      assert credentials.password_hash == "some updated password_hash"
    end

    test "update_credentials/2 with invalid data returns error changeset" do
      credentials = credentials_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_credentials(credentials, @invalid_attrs)
      assert credentials == Accounts.get_credentials!(credentials.id)
    end

    test "delete_credentials/1 deletes the credentials" do
      credentials = credentials_fixture()
      assert {:ok, %Credentials{}} = Accounts.delete_credentials(credentials)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credentials!(credentials.id) end
    end

    test "change_credentials/1 returns a credentials changeset" do
      credentials = credentials_fixture()
      assert %Ecto.Changeset{} = Accounts.change_credentials(credentials)
    end
  end
end
