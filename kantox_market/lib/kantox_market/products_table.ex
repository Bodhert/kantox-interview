defmodule KantoxMarket.ProductsTable do
  @moduledoc """
  A GenServer-based module for managing a table of products using ETS (Erlang Term Storage).

  This module initializes an ETS table with a predefined set of products and provides functions
  to retrieve product information.

  ## Products

  The following products are preloaded into the ETS table:

    - **GR1**: Green tea, priced at €3.11
    - **SR1**: Strawberries, priced at €5.00
    - **CF1**: Coffee, priced at €11.23
  """
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

  @doc """
  Loads the predefined products into the ETS table.

  This function creates an ETS table and inserts the predefined set of products.

  ## Returns

    - `:ok` if the products are successfully loaded into the ETS table.
  """
  @spec load_products() :: :ok
  def load_products do
    :ets.new(:products, [:set, :protected, :named_table, {:read_concurrency, true}])

    Enum.each(@products, fn product ->
      :ets.insert(:products, {product[:code], product})
    end)
  end

  @doc """
  Retrieves a product from the ETS table by its code.

  ## Parameters

    - `code`: The code of the product to retrieve.

  ## Returns

    - `{:ok, product}`: Returns the product if found in the ETS table.
    - `:error`: Returns `:error` if the product is not found.
  """
  @spec get_product(String.t()) :: {:ok, map()} | :error
  def get_product(code) do
    case :ets.lookup(:products, code) do
      [{^code, product}] -> {:ok, product}
      [] -> :error
    end
  end
end
