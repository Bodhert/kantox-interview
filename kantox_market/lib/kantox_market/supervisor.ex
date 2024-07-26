defmodule KantoxMarket.Supervisor do
  require Logger

  use Supervisor

  def start_link(_arg) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      KantoxMarket.ProductsTable,
      KantoxMarket.ShoppingCart
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
