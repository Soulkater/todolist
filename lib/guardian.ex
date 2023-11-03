# Toutes ces fonctions sont des fonctions de Guardien que j'ai trouvé directement sur internet
defmodule Todolist.Guardian do
  use Guardian, otp_app: :todolist

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Todolist.Accounts.get_user!(id)
    {:ok,  resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
