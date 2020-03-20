defmodule Migrations.CreatePostsInOtherSchema do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:posts, prefix: :other_schema) do
      add(:title, :string)
      add(:body, :string)
      add(:published, :boolean)

      timestamps()
    end
  end
end
