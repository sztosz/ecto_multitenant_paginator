use Mix.Config

config :ecto_multitenant_paginator, ecto_repos: [EctoMultitenantPaginator.Ecto.Repo]

config :ecto_multitenant_paginator, EctoMultitenantPaginator.Ecto.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "ecto_multitenant_paginator_test",
  username: "ecto_multitenant_paginator_test",
  username: System.get_env("ECTOMULTITENANTPAGINATOR_DB_PASSWORD")

config :logger, :console, level: :error
