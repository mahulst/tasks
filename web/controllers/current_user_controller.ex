defmodule Tasks.CurrentUserController do
  use Tasks.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Tasks.SessionController

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    IO.inspect(user)
    conn
    |> put_status(:ok)
    |> render("show.json", user: user)
  end
end