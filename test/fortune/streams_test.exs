defmodule Fortune.StreamsTest do
  use Fortune.DataCase

  alias Fortune.Streams

  describe "trades" do
    alias Fortune.Streams.Trade

    import Fortune.StreamsFixtures

    @invalid_attrs %{active: nil, symbol: nil}

    test "list_trades/0 returns all trades" do
      trade = trade_fixture()
      assert Streams.list_trades() == [trade]
    end

    test "get_trade!/1 returns the trade with given id" do
      trade = trade_fixture()
      assert Streams.get_trade!(trade.id) == trade
    end

    test "create_trade/1 with valid data creates a trade" do
      valid_attrs = %{active: true, symbol: "some symbol"}

      assert {:ok, %Trade{} = trade} = Streams.create_trade(valid_attrs)
      assert trade.active == true
      assert trade.symbol == "some symbol"
    end

    test "create_trade/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Streams.create_trade(@invalid_attrs)
    end

    test "update_trade/2 with valid data updates the trade" do
      trade = trade_fixture()
      update_attrs = %{active: false, symbol: "some updated symbol"}

      assert {:ok, %Trade{} = trade} = Streams.update_trade(trade, update_attrs)
      assert trade.active == false
      assert trade.symbol == "some updated symbol"
    end

    test "update_trade/2 with invalid data returns error changeset" do
      trade = trade_fixture()
      assert {:error, %Ecto.Changeset{}} = Streams.update_trade(trade, @invalid_attrs)
      assert trade == Streams.get_trade!(trade.id)
    end

    test "delete_trade/1 deletes the trade" do
      trade = trade_fixture()
      assert {:ok, %Trade{}} = Streams.delete_trade(trade)
      assert_raise Ecto.NoResultsError, fn -> Streams.get_trade!(trade.id) end
    end

    test "change_trade/1 returns a trade changeset" do
      trade = trade_fixture()
      assert %Ecto.Changeset{} = Streams.change_trade(trade)
    end
  end

  describe "klines" do
    alias Fortune.Streams.Kline

    import Fortune.StreamsFixtures

    @invalid_attrs %{active: nil, symbol: nil, interval: nil}

    test "list_klines/0 returns all klines" do
      kline = kline_fixture()
      assert Streams.list_klines() == [kline]
    end

    test "get_kline!/1 returns the kline with given id" do
      kline = kline_fixture()
      assert Streams.get_kline!(kline.id) == kline
    end

    test "create_kline/1 with valid data creates a kline" do
      valid_attrs = %{active: true, symbol: "some symbol", interval: "some interval"}

      assert {:ok, %Kline{} = kline} = Streams.create_kline(valid_attrs)
      assert kline.active == true
      assert kline.symbol == "some symbol"
      assert kline.interval == "some interval"
    end

    test "create_kline/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Streams.create_kline(@invalid_attrs)
    end

    test "update_kline/2 with valid data updates the kline" do
      kline = kline_fixture()
      update_attrs = %{active: false, symbol: "some updated symbol", interval: "some updated interval"}

      assert {:ok, %Kline{} = kline} = Streams.update_kline(kline, update_attrs)
      assert kline.active == false
      assert kline.symbol == "some updated symbol"
      assert kline.interval == "some updated interval"
    end

    test "update_kline/2 with invalid data returns error changeset" do
      kline = kline_fixture()
      assert {:error, %Ecto.Changeset{}} = Streams.update_kline(kline, @invalid_attrs)
      assert kline == Streams.get_kline!(kline.id)
    end

    test "delete_kline/1 deletes the kline" do
      kline = kline_fixture()
      assert {:ok, %Kline{}} = Streams.delete_kline(kline)
      assert_raise Ecto.NoResultsError, fn -> Streams.get_kline!(kline.id) end
    end

    test "change_kline/1 returns a kline changeset" do
      kline = kline_fixture()
      assert %Ecto.Changeset{} = Streams.change_kline(kline)
    end
  end
end
