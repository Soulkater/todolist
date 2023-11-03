defmodule Todolist.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :password_hash, :string
    #
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :password, :password_confirmation])# Remove hash, add pw + pw confirmation
    |> validate_required([:firstname, :lastname, :email, :password, :password_confirmation])# Remove hash, add pw + pw confirmation
    |> validate_format(:email, ~r/@/) # Check that email is valid
    |> validate_length(:password, min: 8) # Check that password length is >= 8
    |> validate_confirmation(:password) # Check that password === password_confirmation
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        salt = :crypto.strong_rand_bytes(16)  # Générez un sel sécurisé
        hashed_password = Pbkdf2.hash_pwd_salt(pass, [salt])

        put_change(changeset, :password_hash, hashed_password)

      _ ->
        changeset
    end
  end


end
