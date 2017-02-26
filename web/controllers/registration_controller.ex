defmodule Tasks.RegistrationController do
  use Tasks.Web, :controller

  alias Tasks.{ Repo, User }

  plug :scrub_params, "user" when action in [ :create ]

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      { :ok, user } ->
        { :ok, jwt, _full_claims } = Guardian.encode_and_sign(user, :token)

        conn
          |> put_status(:created)
          |> render(Tasks.SessionView, "show.json", jwt: jwt, user: user)

      { :error, changeset } ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(Tasks.RegistrationView, "error.json", changeset: changeset)
    end

  end
end