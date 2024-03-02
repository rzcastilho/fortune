defmodule Fortune.Streams.Kline.Query do
  import Ecto.Query
  alias Fortune.Streams.Kline

  def base(), do: Kline

  def filter_by_symbol(query \\ base(), symbol) do
    query
    |> where([k], k.symbol == ^symbol)
  end

  def filter_by_interval(query \\ base(), interval) do
    query
    |> where([k], k.interval == ^interval)
  end

  def filter_active(query \\ base()) do
    query
    |> where([k], k.active == true)
  end
end
