defmodule Migrations.CreateKeyValuesInOtherSchema do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:key_values, primary_key: false, prefix: :other_schema) do
      add(:key, :string, primary_key: true)
      add(:value, :string)
    end
  end
end
