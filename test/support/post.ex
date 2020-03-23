defmodule EctoPaginator.Ecto.Post do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Query

  schema "posts" do
    field(:title, :string)
    field(:body, :string)
    field(:published, :boolean)

    has_many(:comments, EctoPaginator.Ecto.Comment)

    timestamps()
  end

  def published(query) do
    query |> where([p], p.published == true)
  end

  def unpublished(query) do
    query |> where([p], p.published == false)
  end
end
