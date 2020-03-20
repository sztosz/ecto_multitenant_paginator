defprotocol EctoPaginator.Paginator do
  @moduledoc """
  The `EctoPaginator.Paginater` protocol should be implemented for any type that requires pagination.
  """

  @doc """
  The paginate function will be invoked with the item to paginate along with a `EctoPaginator.Config`. It is expected to return a `EctoPaginator.Page`.
  """
  @spec paginate(any, EctoPaginator.Config.t()) :: EctoPaginator.Page.t()
  def paginate(pageable, config)
end
