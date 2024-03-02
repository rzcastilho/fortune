defmodule Fortune.Parser do
  def parse(%{
        "E" => event_time,
        "T" => trade_time,
        "a" => sell_order_id,
        "b" => buy_order_id,
        "e" => "trade",
        "p" => price,
        "q" => quantity,
        "s" => symbol,
        "t" => trade_id,
        "m" => market_maker
      }) do
    {
      :ok,
      %{
        event_time: DateTime.from_unix!(event_time, :millisecond),
        trade_time: DateTime.from_unix!(trade_time, :millisecond),
        sell_order_id: sell_order_id,
        buy_order_id: buy_order_id,
        event_type: :trade,
        price: price,
        quantity: quantity,
        symbol: symbol,
        trade_id: trade_id,
        market_maker: market_maker
      }
    }
  end

  def parse(%{
        "E" => event_time,
        "e" => "kline",
        "k" => %{
          "L" => last_trade_id,
          "Q" => taker_buy_quote_asset_volume,
          "T" => kline_close_time,
          "V" => taker_buy_base_asset_volume,
          "c" => close_price,
          "f" => first_trade_id,
          "h" => high_price,
          "i" => interval,
          "l" => low_price,
          "n" => number_of_trades,
          "o" => open_price,
          "q" => quote_asset_volume,
          "s" => symbol,
          "t" => kline_start_time,
          "v" => base_asset_volume,
          "x" => kline_closed
        }
      }) do
    {
      :ok,
      %{
        event_time: DateTime.from_unix!(event_time, :millisecond),
        event_type: :kline,
        kline: %{
          symbol: symbol,
          interval: interval,
          open_price: open_price,
          close_price: close_price,
          high_price: high_price,
          low_price: low_price,
          closed: kline_closed,
          start_time: DateTime.from_unix!(kline_start_time, :millisecond),
          close_time: DateTime.from_unix!(kline_close_time, :millisecond),
          first_trade_id: first_trade_id,
          last_trade_id: last_trade_id,
          number_of_trades: number_of_trades,
          quote_asset_volume: quote_asset_volume,
          base_asset_volume: base_asset_volume,
          taker_buy_quote_asset_volume: taker_buy_quote_asset_volume,
          taker_buy_base_asset_volume: taker_buy_base_asset_volume
        }
      }
    }
  end

  def parse(event), do: {:error, "unknown event: #{inspect(event)}"}
end
