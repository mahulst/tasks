defmodule Tasks.UserSocket do
  use Phoenix.Socket

  alias Tasks.{ Repo, User }
  ## Channels
  # channel "room:*", Tasks.RoomChannel

  channel "users:*", Tasks.UserChannel
  channel "boards:*", Tasks.BoardChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  transport :longpoll, Phoenix.Transports.LongPoll

  # transport :longpoll, Phoenix.Transports.LongPoll


  def connect(%{ "token" => token }, socket) do
    case Guardian.decode_and_verify(token) do
     { :ok, claims } ->
        case GuardianSerializer.from_token(claims["sub"]) do
          { :ok, user } ->
            { :ok, assign(socket, :current_user, user ) }
          { :error, _reason } ->
            :error
        end
     { :error, _reason } ->
        :error
    end
  end

  def connect(_params, _socker), do: :error

  def id(socket), do: "users_socket:#{socket.assigns.current_user.id}"
end
