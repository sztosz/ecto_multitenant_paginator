defmodule EctoMultitenantPaginator.Ecto.Comment do
  @moduledoc false

  use Ecto.Schema

  schema "comments" do
    field(:body, :string)

    belongs_to(:post, EctoMultitenantPaginator.Ecto.Post)

    timestamps()
  end
end
