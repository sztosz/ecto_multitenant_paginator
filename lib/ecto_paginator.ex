defmodule EctoMultitenantPaginator do
  @moduledoc """
  Documentation for `EctoMultitenantPaginator`.
  """
  defmacro __using__(opts) do
    quote do
      @ecto_multitenant_paginator_defaults unquote(opts)

      @spec ecto_multitenant_paginator_defaults() :: Keyword.t()
      def ecto_multitenant_paginator_defaults, do: @ecto_multitenant_paginator_defaults

      @spec paginate(any, map | Keyword.t()) :: EctoMultitenantPaginator.Page.t()
      def paginate(pageable, options \\ []) do
        EctoMultitenantPaginator.paginate(
          pageable,
          EctoMultitenantPaginator.Config.new(
            __MODULE__,
            @ecto_multitenant_paginator_defaults,
            options
          )
        )
      end
    end
  end

  @doc false
  @spec paginate(any, EctoMultitenantPaginator.Config.t()) :: EctoMultitenantPaginator.Page.t()
  def paginate(pageable, %EctoMultitenantPaginator.Config{} = config) do
    EctoMultitenantPaginator.Paginator.paginate(pageable, config)
  end

  @doc false
  @spec paginate(any, map | Keyword.t()) :: EctoMultitenantPaginator.Page.t()
  def paginate(pageable, options) do
    EctoMultitenantPaginator.paginate(pageable, EctoMultitenantPaginator.Config.new(options))
  end
end
