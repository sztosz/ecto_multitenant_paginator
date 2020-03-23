defmodule EctoPaginator.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :ecto_paginator,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      package: package(),
      description: description(),
      source_url: "https://github.com/sztosz/ecto_paginator"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [applications: applications(Mix.env())]
  end

  defp applications(:test), do: [:postgrex, :ecto, :logger, :telemetry]
  defp applications(_), do: [:logger]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0", only: :test},
      {:ex_doc, "~> 0.20.0", only: :dev},
      {:postgrex, "~> 0.15.0", only: :test}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/sztosz/ecto_paginator"}
    ]
  end

  defp description() do
    """
    Scrivener and Scrivener.Ecto rewrite with added support of multitenancy via prefix Repo option.
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
