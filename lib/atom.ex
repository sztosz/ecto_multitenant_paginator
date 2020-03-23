defimpl EctoMultitenantPaginator.Paginator, for: Atom do
  @moduledoc false

  @spec paginate(atom, EctoMultitenantPaginator.Config.t()) :: EctoMultitenantPaginator.Page.t()
  def paginate(atom, config) do
    atom
    |> Ecto.Queryable.to_query()
    |> EctoMultitenantPaginator.Paginator.paginate(config)
  end
end
