defmodule EctoPaginator.Ecto.TestCase do
  @moduledoc false

  alias Ecto.Adapters.SQL.Sandbox
  alias EctoPaginator.Ecto.Repo

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

EctoPaginator.Ecto.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(EctoPaginator.Ecto.Repo, :manual)

ExUnit.start()
