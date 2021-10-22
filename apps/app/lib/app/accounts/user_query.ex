defmodule App.Accounts.UserQuery do
  import Ecto.Query, warn: false
  alias App.Accounts.User

  def not_deleted(query \\ User) do
    from u in query,
      where: u.is_deleted == false
  end

  def limit(query \\ User, limit) do
    from u in query,
      limit: ^limit
  end

  def text_search(query \\ User, text_search)
  def text_search(query, nil), do: query
  def text_search(query, ""), do: query

  def text_search(query, text_search) do
    name_term = "%#{text_search}%"

    from(
      u in query,
      where: ilike(u.name, ^name_term) or ilike(u.email, ^name_term)
    )
  end

  def order_by(query \\ Post, default \\ :newest)

  def order_by(query, :newest) do
    from u in query, order_by: [desc: u.inserted_at]
  end

  def order_by(query, _), do: query
end
