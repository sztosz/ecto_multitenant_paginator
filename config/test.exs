use Mix.Config

config :ecto_paginator, ecto_repos: [EctoPaginator.Ecto.Repo]

config :ecto_paginator, EctoPaginator.Ecto.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "ecto_paginator_test",
  username: "ecto_paginator_test",
  username: System.get_env("ECTOPAGINATOR_DB_PASSWORD")

config :logger, :console, level: :error
