defmodule KantoxMarket.ShoppingCart do
  use GenServer

  require Logger
  alias KantoxMarket.ProductsTable

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_init_arg) do
    {:ok, %{}}
  end

  def add_item_to_cart(item) do
    GenServer.call(__MODULE__, {:add, item})
  end

  def calculate_total() do
    GenServer.call(__MODULE__, :calculate_total)
  end

  def handle_call({:add, item}, _from, state) do
    with {:ok, item_info} <- ProductsTable.get_product(item) do
      {:reply, :ok, update_cart(state, item_info.code)}
    else
      :error ->
        Logger.info("product code #{item} is not in our catalog")
        {:reply, :ok, state}
    end
  end

  def handle_call(:calculate_total, _, state) do
    Enum.reduce(state, Money.zero(:EUR), fn {product, quantity}, acc ->
      case ProductsTable.get_product(product) do
        {:ok, product_info} ->
          Money.add!(acc, maybe_apply_discount(product, quantity, product_info.price))

        :error ->
          acc
      end
    end)
    |> IO.puts()

    {:reply, :ok, state}
  end

  # TODO test this busness rules.
  defp maybe_apply_discount("GR1", quantity, price) when quantity >= 2 do
    if rem(quantity, 2) == 0 do
      price
      |> Money.mult!(quantity)
      |> Money.div!(2)
    else
      price
      |> Money.mult!(quantity - 1)
      |> Money.div!(2)
      |> Money.add!(price)
    end
  end

  defp maybe_apply_discount(_, quantity, price), do: Money.mult!(price, quantity)

  defp update_cart(state, item_code) when is_map(state) do
    Map.update(state, item_code, 1, fn current_items_quantity -> current_items_quantity + 1 end)
  end
end
