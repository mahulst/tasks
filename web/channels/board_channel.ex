defmodule Tasks.BoardChannel do
  use Tasks.Web, :channel

  alias Tasks.{ List, Board, Card }

  def join("boards:" <> board_id, _params, socket) do
    board = get_current_board(socket, board_id)
    { :ok, %{ board: board }, assign(socket, :board, board) }
  end

  def handle_in("members:add", %{"email" => email}, socket) do
      board = socket.assigns.board
      user = Tasks.User
        |> Repo.get_by(email: email)

      changeset = user
      |> build_assoc(:user_boards)
      |> Tasks.UserBoard.changeset(%{board_id: board.id})

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

  def handle_in("lists:create", %{"list" => list_params}, socket) do
    board = socket.assigns.board

    changeset = board
      |> build_assoc(:lists)
      |> List.changeset(list_params)

    case Repo.insert(changeset) do
      {:ok, list} ->
        list = Repo.preload(list, [:board, :cards])

        broadcast! socket, "list:created", %{list: list}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error creating list"}}, socket}
    end
  end


  def handle_in("cards:create", %{"card" => card_params}, socket) do
    board = socket.assigns.board
    changeset = board
      |> assoc(:lists)
      |> Repo.get!(card_params["list_id"])
      |> build_assoc(:cards)
      |> Card.changeset(card_params)

    case Repo.insert(changeset) do
      {:ok, card} ->
        card = board
          |> assoc(:cards)
          |> Repo.get!(card.id)

        broadcast! socket, "card:created", %{card: card}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error creating card"}}, socket}
    end
  end


  def handle_in("card:update", %{"card" => card_params}, socket) do
    card = socket.assigns.board
      |> assoc(:cards)
      |> Repo.get!(card_params["id"])
    IO.inspect(card)
    IO.inspect(card_params)

    changeset = Card.update_changeset(card, card_params)
    IO.inspect(changeset)
    case Repo.update(changeset) do
      {:ok, card} ->
        board = get_current_board(socket)

        card = Card
        |> Repo.get(card.id)

        broadcast! socket, "card:updated", %{board: board, card: card}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error updating card"}}, socket}
    end
  end

  def handle_in("list:update", %{"list" => list_params}, socket) do
    list = socket.assigns.board
      |> assoc(:lists)
      |> Repo.get!(list_params["id"])

    changeset = List.changeset(list, list_params)

    case Repo.update(changeset) do
      {:ok, _list} ->
        board = get_current_board(socket)
        broadcast! socket, "list:updated", %{board: board}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error updating list"}}, socket}
    end
  end

  defp get_current_board(socket, board_id) do
    socket.assigns.current_user
    |> assoc(:boards)
    |> Board.preload_all()
    |> Repo.get(board_id)
  end

  defp get_current_board(socket), do: get_current_board(socket, socket.assigns.board.id)

end
