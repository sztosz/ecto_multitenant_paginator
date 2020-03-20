defmodule EctoPaginator.Paginator.Ecto.OtherSchemaQueryTest do
  @moduledoc false

  use EctoPaginator.Ecto.TestCase

  alias EctoPaginator.Ecto.Comment
  alias EctoPaginator.Ecto.KeyValue
  alias EctoPaginator.Ecto.Post
  alias EctoPaginator.Ecto.Repo

  defp create_posts do
    unpublished_post =
      %Post{title: "Title unpublished", body: "Body unpublished", published: false}
      |> Repo.insert!(prefix: :other_schema)

    Enum.each(1..2, fn i ->
      %Comment{body: "Body #{i}", post_id: unpublished_post.id}
      |> Repo.insert!(prefix: :other_schema)
    end)

    Enum.map(1..6, fn i ->
      %Post{title: "Title #{i}", body: "Body #{i}", published: true}
      |> Repo.insert!(prefix: :other_schema)
    end)
  end

  defp create_key_values do
    Enum.map(1..10, fn i ->
      %KeyValue{key: "key_#{i}", value: rem(i, 2) |> to_string}
      |> Repo.insert!(prefix: :other_schema)
    end)
  end

  describe "paginate" do
    test "paginates an unconstrained query" do
      create_posts()
      page = Repo.paginate(Post, prefix: :other_schema)
      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end

    test "page information is correct with no results" do
      page = Repo.paginate(Post, prefix: :other_schema)
      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 0
      assert page.total_pages == 1
    end

    test "uses defaults from the repo" do
      posts = create_posts()
      page = Post |> Post.published() |> Repo.paginate(prefix: :other_schema)
      assert page.page_size == 5
      assert page.page_number == 1
      assert page.entries == Enum.take(posts, 5)
      assert page.total_entries == 6
      assert page.total_pages == 2
    end

    test "it handles preloads" do
      create_posts()

      page =
        Post |> Post.published() |> preload(:comments) |> Repo.paginate(prefix: :other_schema)

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_pages == 2
    end

    test "it handles offsets" do
      create_posts()

      page =
        Post |> Post.unpublished() |> Repo.paginate(options: [offset: 1], prefix: :other_schema)

      assert page.entries |> length == 0
      assert page.page_number == 1
      assert page.total_pages == 1

      page =
        Post |> Post.published() |> Repo.paginate(options: [offset: 2], prefix: :other_schema)

      assert page.entries |> length == 4
      assert page.page_number == 1
      assert page.total_pages == 2
    end

    test "it handles complex selects" do
      create_posts()

      page =
        Post
        |> join(:left, [p], c in assoc(p, :comments))
        |> group_by([p], p.id)
        |> select([p], sum(p.id))
        |> Repo.paginate(prefix: :other_schema)

      assert page.total_entries == 7
    end

    test "it handles complex order_by" do
      create_posts()

      page =
        Post
        |> select([p], fragment("? as aliased_title", p.title))
        |> order_by([p], fragment("aliased_title"))
        |> Repo.paginate(prefix: :other_schema)

      assert page.total_entries == 7
    end

    test "can be provided the current page and page size as a params map" do
      posts = create_posts()

      page =
        Post
        |> Post.published()
        |> Repo.paginate(%{"page" => "2", "page_size" => "3", "prefix" => :other_schema})

      assert page.page_size == 3
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 3)
      assert page.total_pages == 2
    end

    test "can be provided the current page and page size as options" do
      posts = create_posts()

      page =
        Post |> Post.published() |> Repo.paginate(page: 2, page_size: 3, prefix: :other_schema)

      assert page.page_size == 3
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 3)
      assert page.total_pages == 2
    end

    test "can be provided the caller as options" do
      create_posts()
      parent = self()
      task = Task.async(fn -> Repo.paginate(Post, caller: parent, prefix: :other_schema) end)
      page = Task.await(task)
      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end

    test "can be provided the caller as a map" do
      create_posts()
      parent = self()

      task =
        Task.async(fn ->
          Post |> Repo.paginate(%{"caller" => parent, "prefix" => :other_schema})
        end)

      page = Task.await(task)
      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end

    test "will respect the max_page_size configuration" do
      create_posts()

      page =
        Post
        |> Post.published()
        |> Repo.paginate(%{"page" => "1", "page_size" => "20", "prefix" => :other_schema})

      assert page.page_size == 10
    end

    test "will respect total_entries passed to paginate" do
      create_posts()

      page =
        Post
        |> Post.published()
        |> Repo.paginate(options: [total_entries: 130], prefix: :other_schema)

      assert page.total_entries == 130
    end

    test "will use total_pages if page_numer is too large" do
      posts = create_posts()
      page = Post |> Post.published() |> Repo.paginate(page: 3, prefix: :other_schema)
      assert page.page_number == 2
      assert page.entries == posts |> Enum.reverse() |> Enum.take(1)
    end

    test "allows overflow page numbers if option is specified" do
      create_posts()

      page =
        Post
        |> Post.published()
        |> Repo.paginate(
          page: 3,
          options: [allow_overflow_page_number: true],
          prefix: :other_schema
        )

      assert page.page_number == 3
      assert page.entries == []
    end

    test "can be used on a table with any primary key" do
      create_key_values()
      page = KeyValue |> KeyValue.zero() |> Repo.paginate(page_size: 2, prefix: :other_schema)
      assert page.total_entries == 5
      assert page.total_pages == 3
    end

    test "can be used with a group by clause" do
      create_posts()

      page =
        Post
        |> join(:left, [p], c in assoc(p, :comments))
        |> group_by([p], p.id)
        |> Repo.paginate(prefix: :other_schema)

      assert page.total_entries == 7
    end

    test "can be used with a group by clause on field other than id" do
      create_posts()

      page =
        Post
        |> group_by([p], p.body)
        |> select([p], p.body)
        |> Repo.paginate(prefix: :other_schema)

      assert page.total_entries == 7
    end

    test "can be used with a group by clause on field on joined table" do
      create_posts()

      page =
        Post
        |> join(:inner, [p], c in assoc(p, :comments))
        |> group_by([p, c], c.body)
        |> select([p, c], {c.body, count("*")})
        |> Repo.paginate(prefix: :other_schema)

      assert page.total_entries == 2
    end

    test "can be used with compound group by clause" do
      create_posts()

      page =
        Post
        |> join(:inner, [p], c in assoc(p, :comments))
        |> group_by([p, c], [c.body, p.title])
        |> select([p, c], {c.body, p.title, count("*")})
        |> Repo.paginate(prefix: :other_schema)

      assert page.total_entries == 2
    end

    test "can be provided a EctoPaginator.Config directly" do
      posts = create_posts()

      config = %EctoPaginator.Config{
        module: Repo,
        page_number: 2,
        page_size: 4,
        options: [],
        prefix: :other_schema
      }

      page = Post |> Post.published() |> EctoPaginator.paginate(config)
      assert page.page_size == 4
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 4)
      assert page.total_pages == 2
    end

    test "can be provided a keyword directly" do
      posts = create_posts()

      page =
        Post
        |> Post.published()
        |> EctoPaginator.paginate(module: Repo, page: 2, page_size: 4, prefix: :other_schema)

      assert page.page_size == 4
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 4)
      assert page.total_pages == 2
    end

    test "can be provided a map directly" do
      posts = create_posts()

      page =
        Post
        |> Post.published()
        |> EctoPaginator.paginate(%{
          "module" => Repo,
          "page" => 2,
          "page_size" => 4,
          "prefix" => :other_schema
        })

      assert page.page_size == 4
      assert page.page_number == 2
      assert page.entries == Enum.drop(posts, 4)
      assert page.total_pages == 2
    end

    test "pagination plays nice with distinct on in the query" do
      create_posts()

      page =
        Post
        |> distinct([p], asc: p.title, asc: p.inserted_at)
        |> Repo.paginate(prefix: :other_schema)

      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end

    test "pagination plays nice with absolute distinct in the query" do
      create_posts()
      page = Post |> distinct(true) |> Repo.paginate(prefix: :other_schema)
      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end

    test "pagination plays nice with a singular distinct in the query" do
      create_posts()
      page = Post |> distinct(:id) |> Repo.paginate(prefix: :other_schema)
      assert page.page_size == 5
      assert page.page_number == 1
      assert page.total_entries == 7
      assert page.total_pages == 2
    end
  end
end
