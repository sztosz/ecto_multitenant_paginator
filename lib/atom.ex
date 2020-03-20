defimpl EctoPaginator.Paginator, for: Atom do
  @moduledoc false

  @spec paginate(atom, EctoPaginator.Config.t()) :: EctoPaginator.Page.t()
  def paginate(atom, config) do
    atom
    |> Ecto.Queryable.to_query()
    |> EctoPaginator.Paginator.paginate(config)
  end
end
