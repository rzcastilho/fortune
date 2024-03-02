defmodule Fortune.Streamer do
  use WebSockex

  alias Fortune.{Parser, Streams}
  alias Phoenix.PubSub

  require Logger

  @stream_endpoint "wss://stream.binance.com:9443/ws/"

  @trades_topic "trades"
  @klines_topic "klines"

  def start_link([symbol]) do
    symbol = String.downcase(symbol)

    Logger.info("Starting trading streamer for symbol #{symbol}")

    case Streams.start_trade(symbol) do
      {:ok, trade} ->
        case WebSockex.start_link(
               "#{@stream_endpoint}#{symbol}@trade",
               __MODULE__,
               trade,
               name: process_name(symbol)
             ) do
          {:ok, pid} ->
            PubSub.broadcast(
              Fortune.PubSub,
              @trades_topic,
              {:start, %{event: :trade, symbol: symbol}}
            )

            {:ok, pid}

          error ->
            error
        end

      {:error, :not_found} ->
        Logger.error("Trade symbol #{symbol} not found")
        :error

      {:error, :already_started} ->
        Logger.error("Trade Symbol #{symbol} already started")
        :error
    end
  end

  def start_link([symbol, interval]) do
    symbol = String.downcase(symbol)

    Logger.info("Starting kline streamer with #{interval} interval for symbol #{symbol}")

    case Streams.start_kline(symbol, interval) do
      {:ok, kline} ->
        case WebSockex.start_link(
               "#{@stream_endpoint}#{symbol}@kline_#{interval}",
               __MODULE__,
               kline,
               name: process_name(symbol, interval)
             ) do
          {:ok, pid} ->
            PubSub.broadcast(
              Fortune.PubSub,
              @klines_topic,
              {:start, %{event: :kline, symbol: symbol, interval: interval}}
            )

            {:ok, pid}

          error ->
            error
        end

      {:error, :not_found} ->
        Logger.error("Kline symbol #{symbol} with interval #{interval} not found")
        :error

      {:error, :already_started} ->
        Logger.error("Kline Symbol #{symbol} with interval #{interval} already started")
        :error
    end
  end

  def handle_frame({:text, msg}, %Streams.Trade{symbol: symbol} = state) do
    with {:ok, json} <- Jason.decode(msg),
         {:ok, parsed} <- Parser.parse(json) do
      Logger.debug("Event received: #{inspect(parsed)})")
      PubSub.broadcast(Fortune.PubSub, "trade:#{symbol}", parsed)
    else
      {:error, e} ->
        Logger.error("Error parsing event: #{inspect(e)}")
    end

    {:ok, state}
  end

  def handle_frame({:text, msg}, %Streams.Kline{symbol: symbol, interval: interval} = state) do
    with {:ok, json} <- Jason.decode(msg),
         {:ok, parsed} <- Parser.parse(json) do
      Logger.debug("Event received: #{inspect(parsed)})")
      PubSub.broadcast(Fortune.PubSub, "kline:#{symbol}:#{interval}", parsed)
    else
      {:error, e} ->
        Logger.error("Error parsing event: #{inspect(e)}")
    end

    {:ok, state}
  end

  def handle_frame(unhandled, state) do
    Logger.warning("Unhandled event: #{inspect(unhandled)}")
    {:ok, state}
  end

  defp process_name(symbol), do: String.to_atom("#{symbol}@streamer")

  defp process_name(symbol, interval), do: String.to_atom("#{symbol}_#{interval}@streamer")
end
