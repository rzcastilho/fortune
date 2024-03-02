defmodule Fortune.Streams.Trade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trades" do
    field :active, :boolean, default: false
    field :symbol, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(trade, attrs) do
    trade
    |> cast(attrs, [:symbol, :active])
    |> validate_required([:symbol, :active])
    |> unique_constraint(:symbol)
  end
end
