defmodule Tasks.BoardChannel do
  use Tasks.Web, :channel

  alias Tasks.Board

  def join("boards:" <> board_id, _params, socket) do
    board = get_current_board(socket, board_id)
    { :ok, %{ board: board }, assign(socket, :board, board) }
  end

  def handle_in("members:add", %{"email" => email}, socket) do
      IO.inspect('!!!!')
      board = socket.assigns.board
      user = Tasks.User
        |> Repo.get_by(email: email)

      IO.inspect(user)


      changeset = user
      |> build_assoc(:user_boards)
      |> Tasks.UserBoard.changeset(%{board_id: board.id})
      IO.inspect('!!!!')

      case Repo.insert(changeset) do
        {:ok, _board_user} ->
          broadcast! socket, "member:added", %{user: user}
          Tasks.Endpoint.broadcast_from! self(), "users:#{user.id}", "boards:add", %{board: board}
          {:noreply, socket}

        {:error, %{errors: [user_id: _error]}} ->
          {:reply, {:error, %{error: "User already added"}}, socket}

        {:error, _changeset} ->
          {:reply, {:error, %{error: "Error adding new member"}}, socket}
      end
  end

  defp get_current_board(socket, board_id) do
    socket.assigns.current_user
    |> assoc(:boards)
    |> Board.preload_all()
    |> Repo.get(board_id)
  end
end
