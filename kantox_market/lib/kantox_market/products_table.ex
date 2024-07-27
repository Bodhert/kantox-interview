defmodule KantoxMarket.ProductsTable do
  use GenServer

  @products [
    %{code: "GR1", name: "Green tea", price: Money.new!(:EUR, "3.11")},
    %{code: "SR1", name: "Strawberries", price: Money.new!(:EUR, "5.00")},
    %{code: "CF1", name: "Coffee", price: Money.new!(:EUR, "11.23")}
  ]

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_init_arg) do
    load_products()
    {:ok, :noop}
  end

  def load_products do
    :ets.new(:products, [:set, :protected, :named_table, {:read_concurrency, true}])

    Enum.each(@products, fn product ->
      :ets.insert(:products, {product[:code], product})
    end)
  end

  def get_product(code) do
    case :ets.lookup(:products, code) do
      [{^code, product}] -> {:ok, product}
      [] -> :error
    end
  end
end
