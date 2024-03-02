# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fortune.Repo.insert!(%Fortune.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Fortune.Streams

intervals = ~w(1s 1m 3m 5m 15m 30m 1h 2h 4h 6h 8h 12h 1d 3d 1w 1M)

case Binance.Market.get_exchange_info() do
  {:ok, %{symbols: symbols}} ->
    symbols
    |> Enum.map(& &1["symbol"])
    |> Enum.map(&String.downcase/1)
    |> Enum.map(&%{symbol: &1})
    |> Enum.each(&Streams.create_trade/1)

    symbols
    |> Enum.map(& &1["symbol"])
    |> Enum.map(&String.downcase/1)
    |> Enum.flat_map(fn symbol ->
      Enum.map(intervals, fn interval -> %{symbol: symbol, interval: interval} end)
    end)
    |> Enum.each(&Streams.create_kline/1)

  error ->
    error
end
