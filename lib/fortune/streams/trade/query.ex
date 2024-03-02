defmodule Fortune.Streams.Trade.Query do
  import Ecto.Query
  alias Fortune.Streams.Trade

  def base(), do: Trade

  def filter_by_symbol(query \\ base(), symbol) do
    query
    |> where([t], t.symbol == ^symbol)
  end

  def filter_active(query \\ base()) do
    query
    |> where([t], t.active == true)
  end
end
