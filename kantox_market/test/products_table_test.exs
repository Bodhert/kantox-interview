defmodule ProductsTableTest do
  use ExUnit.Case, async: true
  alias KantoxMarket.ProductsTable

  test "Returns the map {:ok, %map()} given the key" do
    assert {:ok, %{code: "GR1", name: "Green tea", price: Money.new!(:EUR, "3.11")}} ==
             ProductsTable.get_product("GR1")
  end

  test "Returns error if the key does not exists" do
    assert :error == ProductsTable.get_product("Non existing key")
  end
end
