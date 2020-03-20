defmodule EctoPaginator.Page do
  @moduledoc """
  A `EctoPaginator.Page` has 5 fields that can be accessed: `entries`, `page_number`, `page_size`, `total_entries` and `total_pages`.

      page = MyApp.Module.paginate(params)

      page.entries
      page.page_number
      page.page_size
      page.total_entries
      page.total_pages
  """

  defstruct [:page_number, :page_size, :total_entries, :total_pages, entries: []]

  @type t :: %__MODULE__{}

  defimpl Enumerable do
    @spec count(EctoPaginator.Page.t()) :: {:error, Enumerable.EctoPaginator.Page}
    def count(_page), do: {:error, __MODULE__}

    @spec member?(EctoPaginator.Page.t(), term) :: {:error, Enumerable.EctoPaginator.Page}
    def member?(_page, _value), do: {:error, __MODULE__}

    @spec reduce(EctoPaginator.Page.t(), Enumerable.acc(), Enumerable.reducer()) ::
            Enumerable.result()
    def reduce(%EctoPaginator.Page{entries: entries}, acc, fun) do
      Enumerable.reduce(entries, acc, fun)
    end

    @spec slice(EctoPaginator.Page.t()) :: {:error, Enumerable.EctoPaginator.Page}
    def slice(_page), do: {:error, __MODULE__}
  end

  defimpl Collectable do
    @spec into(EctoPaginator.Page.t()) ::
            {term, (term, Collectable.command() -> EctoPaginator.Page.t() | term)}
    def into(original) do
      original_entries = original.entries
      impl = Collectable.impl_for(original_entries)
      {_, entries_fun} = impl.into(original_entries)

      fun = fn page, command ->
        %{page | entries: entries_fun.(page.entries, command)}
      end

      {original, fun}
    end
  end
end
