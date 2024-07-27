defmodule KantoxMarket do
  @moduledoc """
  Documentation for `KantoxMarket`.
  """

  alias KantoxMarket.ShoppingCart

  def prompt_console() do
    IO.puts("Enter product separated by , ex: GR1, SR1, CF1")
    IO.puts("(type 'exit' to quit):")
    loop()
  end

  defp loop() do
    input = IO.gets("Basket: ")
    cleaned_input = input |> String.trim() |> String.split(",")
    run_command(cleaned_input)
  end

  defp run_command(["exit"]) do
    IO.puts("Goodbye!")
    System.stop()
  end

  defp run_command(products) when is_list(products) do
    Enum.each(products, fn product -> ShoppingCart.add_item_to_cart(product) end)

    IO.puts(ShoppingCart.calculate_total())
    ShoppingCart.checkout_cart()

    loop()
  end

  defp run_command(input) do
    IO.puts("unable to process #{input}")
    loop()
  end
end
