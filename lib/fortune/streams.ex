defmodule Fortune.Streams do
  @moduledoc """
  The Streams context.
  """

  import Ecto.Query, warn: false
  alias Fortune.Repo

  alias Fortune.Streams.Trade

  @doc """
  Returns the list of trades.

  ## Examples

      iex> list_trades()
      [%Trade{}, ...]

  """
  def list_trades do
    Repo.all(Trade)
  end

  def list_active_trades() do
    Trade.Query.base()
    |> Trade.Query.filter_active()
    |> Repo.all()
  end

  @doc """
  Gets a single trade.

  Raises `Ecto.NoResultsError` if the Trade does not exist.

  ## Examples

      iex> get_trade!(123)
      %Trade{}

      iex> get_trade!(456)
      ** (Ecto.NoResultsError)

  """
  def get_trade!(id), do: Repo.get!(Trade, id)

  @doc """
  Creates a trade.

  ## Examples

      iex> create_trade(%{field: value})
      {:ok, %Trade{}}

      iex> create_trade(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_trade(attrs \\ %{}) do
    %Trade{}
    |> Trade.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trade.

  ## Examples

      iex> update_trade(trade, %{field: new_value})
      {:ok, %Trade{}}

      iex> update_trade(trade, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_trade(%Trade{} = trade, attrs) do
    trade
    |> Trade.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a trade.

  ## Examples

      iex> delete_trade(trade)
      {:ok, %Trade{}}

      iex> delete_trade(trade)
      {:error, %Ecto.Changeset{}}

  """
  def delete_trade(%Trade{} = trade) do
    Repo.delete(trade)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trade changes.

  ## Examples

      iex> change_trade(trade)
      %Ecto.Changeset{data: %Trade{}}

  """
  def change_trade(%Trade{} = trade, attrs \\ %{}) do
    Trade.changeset(trade, attrs)
  end

  def start_trade(symbol) do
    query =
      Trade.Query.base()
      |> Trade.Query.filter_by_symbol(symbol)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      %Trade{active: true} ->
        {:error, :already_started}

      trade ->
        update_trade(trade, %{active: true})
    end
  end

  def stop_trade(symbol) do
    query =
      Trade.Query.base()
      |> Trade.Query.filter_by_symbol(symbol)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      %Trade{active: false} ->
        {:error, :already_stopped}

      trade ->
        update_trade(trade, %{active: false})
    end
  end

  def stop_all_trades() do
    Trade.Query.base()
    |> Trade.Query.filter_active()
    |> Repo.update_all(set: [active: false])
  end

  alias Fortune.Streams.Kline

  @doc """
  Returns the list of klines.

  ## Examples

      iex> list_klines()
      [%Kline{}, ...]

  """
  def list_klines do
    Repo.all(Kline)
  end

  def list_active_klines() do
    Kline.Query.base()
    |> Kline.Query.filter_active()
    |> Repo.all()
  end

  @doc """
  Gets a single kline.

  Raises `Ecto.NoResultsError` if the Kline does not exist.

  ## Examples

      iex> get_kline!(123)
      %Kline{}

      iex> get_kline!(456)
      ** (Ecto.NoResultsError)

  """
  def get_kline!(id), do: Repo.get!(Kline, id)

  @doc """
  Creates a kline.

  ## Examples

      iex> create_kline(%{field: value})
      {:ok, %Kline{}}

      iex> create_kline(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_kline(attrs \\ %{}) do
    %Kline{}
    |> Kline.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a kline.

  ## Examples

      iex> update_kline(kline, %{field: new_value})
      {:ok, %Kline{}}

      iex> update_kline(kline, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_kline(%Kline{} = kline, attrs) do
    kline
    |> Kline.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a kline.

  ## Examples

      iex> delete_kline(kline)
      {:ok, %Kline{}}

      iex> delete_kline(kline)
      {:error, %Ecto.Changeset{}}

  """
  def delete_kline(%Kline{} = kline) do
    Repo.delete(kline)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking kline changes.

  ## Examples

      iex> change_kline(kline)
      %Ecto.Changeset{data: %Kline{}}

  """
  def change_kline(%Kline{} = kline, attrs \\ %{}) do
    Kline.changeset(kline, attrs)
  end

  def start_kline(symbol, interval) do
    query =
      Kline.Query.base()
      |> Kline.Query.filter_by_symbol(symbol)
      |> Kline.Query.filter_by_interval(interval)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      %Kline{active: true} ->
        {:error, :already_started}

      kline ->
        update_kline(kline, %{active: true})
    end
  end

  def stop_kline(symbol, interval) do
    query =
      Kline.Query.base()
      |> Kline.Query.filter_by_symbol(symbol)
      |> Kline.Query.filter_by_interval(interval)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      %Kline{active: false} ->
        {:error, :already_stopped}

      kline ->
        update_kline(kline, %{active: false})
    end
  end

  def stop_all_klines() do
    Kline.Query.base()
    |> Kline.Query.filter_active()
    |> Repo.update_all(set: [active: false])
  end
end
