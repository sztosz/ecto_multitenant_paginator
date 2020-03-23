defmodule Migrations.CreateKeyValues do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:key_values, primary_key: false) do
      add(:key, :string, primary_key: true)
      add(:value, :string)
    end
  end
end
