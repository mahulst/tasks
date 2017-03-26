defmodule Tasks.SessionController do
  use Tasks.Web, :controller

  plug :scrub_params, "session" when action in [ :create ]

  def create(conn, %{ "session" => session_params }) do
    case Tasks.Session.authenticate(session_params) do
      {:ok, user} ->
         new_conn = Guardian.Plug.api_sign_in(conn, user)
         jwt = Guardian.Plug.current_token(new_conn)
         claims = Guardian.Plug.claims(new_conn)

         new_conn
         |> put_resp_header("authorization", "TasksWebsite #{jwt}")
         |> render("show.json", jwt: jwt, user: user)

      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(Tasks.SessionView, "forbidden.json", error: "Not Authenticated")
  end
end