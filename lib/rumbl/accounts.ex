defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Rumbl.Repo
  alias Rumbl.Accounts.User
  import Ecto.Query

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    from(u in User, join: c in assoc(u, :credential), where: c.email == ^email)
    |> Repo.one()
    |> Repo.preload(:credential)
  end

  def authenticate_by_email_and_pass(email, given_pass) do
    user = get_user_by_email(email)

    cond do
      user && Comeonin.Pbkdf2.checkpw(given_pass, user.credential.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        Comeonin.Pbkdf2.dummy_checkpw()
        {:error, :not_found}
    end
  end

  alias Rumbl.Accounts.Credential

  @doc """
  Returns the list of credentials.

  ## Examples

      iex> list_credentials()
      [%Credentials{}, ...]

  """
  def list_credentials do
    Repo.all(Credential)
  end

  @doc """
  Gets a single credentials.

  Raises `Ecto.NoResultsError` if the Credentials does not exist.

  ## Examples

      iex> get_credentials!(123)
      %Credentials{}

      iex> get_credentials!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credentials!(id), do: Repo.get!(Credential, id)

  @doc """
  Creates a credentials.

  ## Examples

      iex> create_credentials(%{field: value})
      {:ok, %Credentials{}}

      iex> create_credentials(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_credentials(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a credentials.

  ## Examples

      iex> update_credentials(credentials, %{field: new_value})
      {:ok, %Credentials{}}

      iex> update_credentials(credentials, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_credentials(%Credential{} = credentials, attrs) do
    credentials
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a credentials.

  ## Examples

      iex> delete_credentials(credentials)
      {:ok, %Credentials{}}

      iex> delete_credentials(credentials)
      {:error, %Ecto.Changeset{}}

  """
  def delete_credentials(%Credential{} = credentials) do
    Repo.delete(credentials)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credentials changes.

  ## Examples

      iex> change_credentials(credentials)
      %Ecto.Changeset{data: %Credentials{}}

  """
  def change_credentials(%Credential{} = credentials, attrs \\ %{}) do
    Credential.changeset(credentials, attrs)
  end
end
