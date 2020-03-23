defprotocol EctoMultitenantPaginator.Paginator do
  @moduledoc """
  The `EctoMultitenantPaginator.Paginater` protocol should be implemented for any type that requires pagination.
  """

  @doc """
  The paginate function will be invoked with the item to paginate along with a `EctoMultitenantPaginator.Config`. It is expected to return a `EctoMultitenantPaginator.Page`.
  """
  @spec paginate(any, EctoMultitenantPaginator.Config.t()) :: EctoMultitenantPaginator.Page.t()
  def paginate(pageable, config)
end
