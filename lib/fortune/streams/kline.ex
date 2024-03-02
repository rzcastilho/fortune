defmodule Fortune.Streams.Kline do
  use Ecto.Schema
  import Ecto.Changeset

  schema "klines" do
    field :active, :boolean, default: false
    field :symbol, :string
    field :interval, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(kline, attrs) do
    kline
    |> cast(attrs, [:symbol, :interval, :active])
    |> validate_required([:symbol, :interval, :active])
    |> validate_inclusion(:interval, ~w(1s 1m 3m 5m 15m 30m 1h 2h 4h 6h 8h 12h 1d 3d 1w 1M))
  end
end
