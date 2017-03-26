defmodule Tasks.Board do
  use Tasks.Web, :model
  alias __MODULE__

  @derive {Poison.Encoder, only: [:id, :name, :user, :members]}

  schema "boards" do
    field :name, :string
    belongs_to :user, Tasks.User

    has_many :user_boards, Tasks.UserBoard
    has_many :members, through: [:user_boards, :user]

    timestamps()
  end


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [ :name, :user_id ])
    |> validate_required([ :name ])
  end

  def preload_all(query) do
#    comments_query = from c in Comment, order_by: [desc: c.inserted_at], preload: :user
#    cards_query = from c in Card, order_by: c.position, preload: [[comments: ^comments_query], :members]
#    lists_query = from l in List, order_by: l.position, preload: [cards: ^cards_query]

    from b in query, preload: [:user]
  end

end
