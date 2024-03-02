defmodule Fortune.Analyzer do
  use GenServer

  alias Phoenix.PubSub

  def start_link([symbol, interval]) do
    GenServer.start_link(
      __MODULE__,
      [symbol, interval],
      name: process_name(symbol, interval)
    )
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  def init([symbol, interval]) do
    PubSub.subscribe(Fortune.PubSub, "kline:#{symbol}:#{interval}")
    {:ok, []}
  end

  def handle_info(%{kline: %{closed: true} = kline}, state) do
    IO.inspect(kline)
    {:noreply, state ++ [kline]}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  defp process_name(symbol, interval), do: String.to_atom("#{symbol}_#{interval}@analyzer")
end
