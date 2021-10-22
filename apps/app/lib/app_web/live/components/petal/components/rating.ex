defmodule AppWeb.Petal.Components.Rating do
  @moduledoc """
  A star rating component.

  eg 3/5 stars:
  <Rating filled_count={3} />

  eg 5/10 stars:
  <Rating filled_count={5} max={10} />
  """

  use AppWeb, :surface_component
  alias AppWeb.Petal.Components.Star

  @doc "The actual rating"
  prop filled_count, :integer, default: 0

  @doc "The maximum rating"
  prop max, :integer, default: 5

  @impl true
  def render(%{filled_count: filled_count, max: max} = assigns) do
    filled_star = trunc(filled_count)
    unfilled_star = max - filled_star

    ~F"""
    <div class="flex gap-0.5">
      <Star fill :for={_i <- 1..filled_star} />
      <Star :if={unfilled_star > 0} :for={_j <- 1..unfilled_star} />
    </div>
    """
  end
end
