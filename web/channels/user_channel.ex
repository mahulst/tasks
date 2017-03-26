defmodule Tasks.UserChannel do
  use Tasks.Web, :channel

  def join("users:" <> user_id, _params, socket) do
    { :ok, socket }
  end
end