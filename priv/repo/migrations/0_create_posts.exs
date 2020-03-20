defmodule Migrations.CreatePosts do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string)
      add(:body, :string)
      add(:published, :boolean)

      timestamps()
    end
  end
end
