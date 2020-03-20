defmodule Migrations.CreateOtherSchema do
  @moduledoc false

  use Ecto.Migration

  def change do
    execute("CREATE SCHEMA other_schema")
  end
end
