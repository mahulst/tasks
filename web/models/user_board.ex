defmodule Tasks.UserBoard do
  use Tasks.Web, :model

  schema "user_boards" do
    belongs_to :user, Tasks.User
    belongs_to :board, Tasks.Board

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [ :user_id, :board_id ])
    |> unique_constraint(:user_id, name: :user_boards_user_id_board_id_index)
  end
end
