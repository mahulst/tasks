defmodule Tasks.PageController do
  use Tasks.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
