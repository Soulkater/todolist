defmodule TodolistWeb.UserController do
  use TodolistWeb, :controller

  alias Todolist.Accounts
  alias Todolist.Accounts.User
  alias Todolist.Guardian

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    # Tentative de création d'un nouvel utilisateur en utilisant les paramètres de l'utilisateur
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         # Génération d'un token JWT en utilisant Guardian et les informations de l'utilisateur
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      # Renvoi d'une réponse JSON contenant le token JWT en tant que "jwt"
      conn |> render("jwt.json", jwt: token)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
