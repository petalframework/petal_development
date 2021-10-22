defmodule DB do
  @moduledoc """
  Utility functions related to the database
  """
  import Ecto.Query
  alias App.Repo
  alias App.Accounts.{User}

  def last(model) do
    Repo.one(from x in model, order_by: [desc: x.id], limit: 1)
  end

  def first(model, preload \\ []) do
    Repo.one(from x in model, order_by: [asc: x.id], limit: 1, preload: ^preload)
  end

  def count(model) do
    Repo.one(from p in model, select: count())
  end

  def limit(query, limit) do
    from x in query, limit: ^limit
  end

  def preload(query, preloads) do
    from x in query,
      preload: ^preloads
  end

  # eg returns [1, 2, 3]. Useful for subqueries
  def id_only(query) do
    from x in query,
      select: x.id
  end

  # eg DB.where(Log, %{post_id: 1814, user_id: 24688, user_type: "user"}) |> Repo.all()
  # only works when `use QueryBuilder` is added to the schema file
  def where(query, params) do
    Enum.reduce(params, query, fn {key, value}, q ->
      QueryBuilder.where(q, {key, value})
    end)
  end

  # order_by(query, [:name, :population])
  # order_by(query, [asc: :name, desc_nulls_first: :population])
  def order_by(query, order) do
    from x in query, order_by: ^order
  end

  def latest_first(query) do
    from x in query, order_by: [desc: x.inserted_at]
  end

  # This will need maintaining as your app evolves
  def delete_all_data() do
    if(Mix.env() == :dev) do
      App.Repo.delete_all(App.Logs.Log)
      users = Repo.all(User)

      # Delete each user one by one. May be communicating with Cloudinary so could take slower than expected
      Enum.each(users, fn user ->
        if user.avatar_cloudinary_id do
          Cloudex.delete(user.avatar_cloudinary_id)
        end

        Repo.delete(user)
      end)
    end
  end
end
