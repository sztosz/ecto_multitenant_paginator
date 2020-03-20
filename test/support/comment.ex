defmodule EctoPaginator.Ecto.Comment do
  @moduledoc false

  use Ecto.Schema

  schema "comments" do
    field(:body, :string)

    belongs_to(:post, EctoPaginator.Ecto.Post)

    timestamps()
  end
end
