defmodule KantoxMarketTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Mox

  setup :set_mox_from_context
  setup :verify_on_exit!

  test "Exits if user prompt exit command" do
    input = "exit\n"

    ShutdownHandlerMock
    |> expect(:stop, fn ->
      :ok
    end)

    capture_output =
      capture_io([input: input], fn ->
        KantoxMarket.prompt_console()
      end)

    assert capture_output =~ "Goodbye"
  end

  test "Displays the price in the output" do
    input = "GR1,CF1\n"

    ShutdownHandlerMock
    |> expect(:stop, fn ->
      :ok
    end)

    capture_output =
      capture_io([input: input], fn ->
        KantoxMarket.prompt_console()
      end)

    assert capture_output =~ "€14.34"
  end

  test "Displays  should be the same no matter if has spaces" do
    input = "    GR1,     CF1\n"

    ShutdownHandlerMock
    |> expect(:stop, fn ->
      :ok
    end)

    capture_output =
      capture_io([input: input], fn ->
        KantoxMarket.prompt_console()
      end)

    assert capture_output =~ "€14.34"
  end
end
