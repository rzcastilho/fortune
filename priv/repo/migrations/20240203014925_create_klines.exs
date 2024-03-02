defmodule Fortune.Repo.Migrations.CreateKlines do
  use Ecto.Migration

  def change do
    create table(:klines) do
      add :symbol, :string
      add :interval, :string
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:klines, [:symbol, :interval],
             name: :unique_index_klines_on_symbol_and_interval
           )
  end
end
