defmodule Tasks.Board do
  use Tasks.Web, :model
  alias __MODULE__

  alias Tasks.{Card, List, User, UserBoard}

  @derive {Poison.Encoder, only: [:id, :name, :user, :members, :lists]}

  schema "boards" do
    field :name, :string
    belongs_to :user, User

    has_many :lists, List
    has_many :cards, through: [:lists, :cards]
    has_many :user_boards, UserBoard
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
       IO.inspect('!!!!')
    cards_query = from c in Card
    lists_query = from l in List, preload: [cards: ^cards_query]

    from b in query, preload: [:user, :members, lists: ^lists_query]
  end

end
