defmodule Rumbl.Accounts do
  alias Rumbl.Repo
  alias Rumbl.Accounts.User
  import Ecto.Query

  def list_users_with_ids(ids) do
    Repo.all(from(u in User, where: u.id in ^ids))
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  @spec get_user(any) :: any
  def get_user(id) do
    Repo.get(User, id)
  end

  @spec get_user!(any) :: any
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @spec get_user_by(any) :: any
  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  @spec list_users :: any
  def list_users do
    Repo.all(User)
  end
end
