defmodule KantoxMarket do
  @moduledoc """
  A module for managing user input.

  This module provides functionality for prompting the user for input via the console,
  processing commands to add items to the shopping cart, calculating the total price,
  and checking out. It handles both product inputs and special commands like `exit` or `eof`.

  ## Example Usage

      # Start the console prompt
      KantoxMarket.prompt_console()
  """

  require Logger
  alias KantoxMarket.ShoppingCart

  @shutdown_handler Application.compile_env(:kantox_market, :shut_down_handler)
  @doc """
  Prompts the user to enter product codes separated by commas or type 'exit' to quit.

  This function displays instructions for the user and then starts the input loop.
  """
  @spec prompt_console() :: :ok
  def prompt_console() do
    IO.puts("Enter product separated by , ex: GR1, SR1, CF1")
    IO.puts("(type 'exit' to quit):")
    loop()
  end

  @spec loop() :: :ok | no_return()
  defp loop() do
    input = IO.gets("Basket: ")
    cleaned_input = clean_input(input)
    run_command(cleaned_input)
  end

  @spec run_command(:eof | [binary()]) :: :ok
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

  @spec clean_input(binary() | :eof) :: [binary()] | :eof
  defp clean_input(input) when is_binary(input) do
    input |> String.trim() |> String.replace(" ", "") |> String.split(",")
  end

  defp clean_input(:eof) do
    :eof
  end
end
