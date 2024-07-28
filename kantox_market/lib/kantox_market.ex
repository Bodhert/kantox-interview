defmodule KantoxMarket do
  @moduledoc """
  Documentation for `KantoxMarket`.
  """

  require Logger
  alias KantoxMarket.ShoppingCart

  @shutdown_handler Application.compile_env(:kantox_market, :shut_down_handler)

  def prompt_console() do
    IO.puts("Enter product separated by , ex: GR1, SR1, CF1")
    IO.puts("(type 'exit' to quit):")
    loop()
  end

  defp loop() do
    input = IO.gets("Basket: ")
    cleaned_input = clean_input(input)
    run_command(cleaned_input)
  end

  defp run_command(["exit"]) do
    IO.puts("Goodbye!")
    @shutdown_handler.stop()
  end

  defp run_command(:eof) do
    IO.puts("Goodbye!")
    @shutdown_handler.stop()
  end

  defp run_command(products) when is_list(products) do
    Enum.each(products, fn product -> ShoppingCart.add_item_to_cart(product) end)

    IO.puts(ShoppingCart.calculate_total())
    ShoppingCart.checkout_cart()

    loop()
  end

  defp run_command(input) do
    IO.puts("unable to process #{input}")
  end

  defp clean_input(input) when is_binary(input) do
    input |> String.trim() |> String.replace(" ", "") |> String.split(",")
  end

  defp clean_input(:eof) do
    :eof
  end
end
