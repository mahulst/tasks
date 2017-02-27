defmodule Tasks.BoardChannel do
  use Tasks.Web, :channel

  alias Tasks.Board

  def join("boards:" <> board_id, _params, socket) do
    board = get_current_board(socket, board_id)

    { :ok, %{ board: board }, assign(socket, :board, board) }
  end

  defp get_current_board(socket, board_id) do
    socket.assigns.current_user
    |> assoc(:boards)
    |> Repo.get(board_id)
  end
end