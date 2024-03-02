defmodule FortuneWeb.ActiveStreamsLive do
  use FortuneWeb, :live_component

  alias Fortune.Streams

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_trades()
      |> assign_klines()
    }
  end

  def assign_trades(socket) do
    trades = Streams.list_active_trades()
    assign(socket, :trades, trades)
  end

  def assign_klines(socket) do
    klines = Streams.list_active_klines()
    assign(socket, :klines, klines)
  end
end
