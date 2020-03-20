defmodule Migrations.CreateCommentsInOtherSchema do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:comments, prefix: :other_schema) do
      add(:body, :string)
      add(:post_id, :integer)

      timestamps()
    end
  end
end
