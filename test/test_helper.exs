defmodule EctoMultitenantPaginator.Ecto.TestCase do
  @moduledoc false

  alias Ecto.Adapters.SQL.Sandbox
  alias EctoMultitenantPaginator.Ecto.Repo

  use ExUnit.CaseTemplate

  using opts do
    quote do
      use ExUnit.Case, unquote(opts)
      import Ecto.Query
    end
  end

  setup do
    :ok = Sandbox.checkout(Repo)
    Sandbox.mode(Repo, {:shared, self()})
  end
end

EctoMultitenantPaginator.Ecto.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(EctoMultitenantPaginator.Ecto.Repo, :manual)

ExUnit.start()
