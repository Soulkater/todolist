defmodule TodolistWeb.UserJSON do
  alias Todolist.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email,
      password_hash: user.password_hash
    }
  end

  # Pour affichier le jwt dans le body
  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

end
