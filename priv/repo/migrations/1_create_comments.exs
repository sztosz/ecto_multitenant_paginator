defmodule Migrations.CreateComments do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:body, :string)
      add(:post_id, :integer)

      timestamps()
    end
  end
end
