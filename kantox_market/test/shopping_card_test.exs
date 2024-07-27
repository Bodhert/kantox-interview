defmodule ShoppingCardTest do
  alias KantoxMarket.ShoppingCart
  use ExUnit.Case, async: true

  setup do
    on_exit(fn ->
      ShoppingCart.checkout_cart()
    end)

    :ok
  end

  test "add a product from the catalog to the cart" do
    assert :ok = ShoppingCart.add_item_to_cart("GR1")
  end

  test "does not break if the item does not exists" do
    assert :ok = ShoppingCart.add_item_to_cart("Non existing item")
  end

  describe "Test buy-one-get-one-free offers and of green tea" do
    test "Buy two teas, get one free" do
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("GR1")

      assert ShoppingCart.calculate_total() == Money.new(:EUR, "3.11")
    end

    test "Buy three teas, only one pair is in discount" do
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("GR1")

      assert ShoppingCart.calculate_total() == Money.new(:EUR, "6.22")
    end
  end

  describe "Strawberries rules" do
    test "Buy two strawberries gives no discount" do
      ShoppingCart.add_item_to_cart("SR1")
      ShoppingCart.add_item_to_cart("SR1")
      assert ShoppingCart.calculate_total() == Money.new(:EUR, "10.00")
    end

    test "Buy three or more strawberries reduces the price to 4.50" do
      ShoppingCart.add_item_to_cart("SR1")
      ShoppingCart.add_item_to_cart("SR1")
      ShoppingCart.add_item_to_cart("SR1")
      assert ShoppingCart.calculate_total() == Money.new(:EUR, "13.50")
    end
  end

  describe "Coffee rules" do
    test "Buy two three coffees  gives no discount" do
      ShoppingCart.add_item_to_cart("CF1")
      ShoppingCart.add_item_to_cart("CF1")
      assert ShoppingCart.calculate_total() == Money.new(:EUR, "22.46")
    end

    test "Buy more than three coffes reduce the original price 2/3" do
      ShoppingCart.add_item_to_cart("CF1")
      ShoppingCart.add_item_to_cart("CF1")
      ShoppingCart.add_item_to_cart("CF1")

      assert ShoppingCart.calculate_total() |> Money.to_string!() ==
               Money.new(:EUR, "22.46") |> Money.to_string!()
    end
  end

  describe "test data" do
    test "first test case" do
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("SR1")
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("CF1")
      assert ShoppingCart.calculate_total() == Money.new(:EUR, "22.45")
    end

    test "first test case (order does not matter)" do
      ShoppingCart.add_item_to_cart("SR1")
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("CF1")
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("GR1")
      assert ShoppingCart.calculate_total() == Money.new(:EUR, "22.45")
    end

    test "third test case" do
      ShoppingCart.add_item_to_cart("SR1")
      ShoppingCart.add_item_to_cart("SR1")
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("SR1")
      assert ShoppingCart.calculate_total() == Money.new(:EUR, "16.61")
    end

    test "fourth test case" do
      ShoppingCart.add_item_to_cart("GR1")
      ShoppingCart.add_item_to_cart("CF1")
      ShoppingCart.add_item_to_cart("SR1")
      ShoppingCart.add_item_to_cart("CF1")
      ShoppingCart.add_item_to_cart("CF1")

      assert ShoppingCart.calculate_total() |> Money.to_string!() ==
               Money.new(:EUR, "30.57") |> Money.to_string!()
    end
  end
end
