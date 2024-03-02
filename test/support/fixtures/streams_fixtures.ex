defmodule Fortune.StreamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fortune.Streams` context.
  """

  @doc """
  Generate a unique trade symbol.
  """
  def unique_trade_symbol, do: "some symbol#{System.unique_integer([:positive])}"

  @doc """
  Generate a trade.
  """
  def trade_fixture(attrs \\ %{}) do
    {:ok, trade} =
      attrs
      |> Enum.into(%{
        active: true,
        symbol: unique_trade_symbol()
      })
      |> Fortune.Streams.create_trade()

    trade
  end

  @doc """
  Generate a kline.
  """
  def kline_fixture(attrs \\ %{}) do
    {:ok, kline} =
      attrs
      |> Enum.into(%{
        active: true,
        interval: "some interval",
        symbol: "some symbol"
      })
      |> Fortune.Streams.create_kline()

    kline
  end
end
