defmodule EctoMultitenantPaginator.Ecto.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :ecto_multitenant_paginator, adapter: Ecto.Adapters.Postgres
  use EctoMultitenantPaginator, page_size: 5, max_page_size: 10
end
