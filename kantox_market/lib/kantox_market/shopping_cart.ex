defmodule KantoxMarket.ShoppingCart do
  @doc """
  Starts the `ShoppingCart` GenServer.
  """
  use GenServer

  require Logger
  alias KantoxMarket.ProductsTable

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_init_arg) do
    {:ok, %{}}
  end

  @doc """
  Adds an item to the shopping cart.

  ## Parameters

    - `item`: The code of the item to add to the cart.

  ## Returns

    - `:ok`: Returns `:ok` indicating the item was added to the cart.
  """
  @spec add_item_to_cart(String.t()) :: :ok
  def add_item_to_cart(item) do
    GenServer.call(__MODULE__, {:add, item})
  end

  @doc """
  Calculates the total cost of items in the cart.

  ## Returns

    - `{:ok, Money.t()}`: Returns the total cost as a `Money` struct if successful.
  """
  @spec calculate_total() :: {:ok, Money.t()}
  def calculate_total() do
    GenServer.call(__MODULE__, :calculate_total)
  end

  @doc """
  Checks out the cart, clearing all items from it.

  ## Returns

    - `:ok`: Returns `:ok` indicating that the cart was successfully checked out and cleared.
  """
  @spec checkout_cart() :: :ok
  def checkout_cart() do
    GenServer.call(__MODULE__, :checkout)
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
    final_cost =
      Enum.reduce(state, Money.zero(:EUR), fn {product, quantity}, acc ->
        case ProductsTable.get_product(product) do
          {:ok, product_info} ->
            Money.add!(acc, maybe_apply_discount(product, quantity, product_info.price))

          :error ->
            acc
        end
      end)

    {:reply, final_cost, state}
  end

  def handle_call(:checkout, _, _state) do
    {:reply, :ok, %{}}
  end

  @spec maybe_apply_discount(String.t(), non_neg_integer(), Money.t()) :: Money.t()
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

  defp maybe_apply_discount("SR1", quantity, _price) when quantity >= 3 do
    price = Money.new!(:EUR, "4.50")
    Money.mult!(price, quantity)
  end

  defp maybe_apply_discount("CF1", quantity, price) when quantity >= 3 do
    price_drop = Decimal.div(Decimal.new(2), Decimal.new(3))
    new_price = Money.mult!(price, price_drop)
    Money.mult!(new_price, quantity)
  end

  defp maybe_apply_discount(_, quantity, price), do: Money.mult!(price, quantity)

  @spec update_cart(map(), String.t()) :: map()
  defp update_cart(state, item_code) when is_map(state) do
    Map.update(state, item_code, 1, fn current_items_quantity -> current_items_quantity + 1 end)
  end
end
