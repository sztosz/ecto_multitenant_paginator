defmodule EctoPaginator do
  @moduledoc """
  Documentation for `EctoPaginator`.
  """
  defmacro __using__(opts) do
    quote do
      @ecto_paginator_defaults unquote(opts)

      @spec ecto_paginator_defaults() :: Keyword.t()
      def ecto_paginator_defaults, do: @ecto_paginator_defaults

      @spec paginate(any, map | Keyword.t()) :: EctoPaginator.Page.t()
      def paginate(pageable, options \\ []) do
        EctoPaginator.paginate(
          pageable,
          EctoPaginator.Config.new(__MODULE__, @ecto_paginator_defaults, options)
        )
      end
    end
  end

  @doc false
  @spec paginate(any, EctoPaginator.Config.t()) :: EctoPaginator.Page.t()
  def paginate(pageable, %EctoPaginator.Config{} = config) do
    EctoPaginator.Paginator.paginate(pageable, config)
  end

  @doc false
  @spec paginate(any, map | Keyword.t()) :: EctoPaginator.Page.t()
  def paginate(pageable, options) do
    EctoPaginator.paginate(pageable, EctoPaginator.Config.new(options))
  end
end
