defmodule ShutdownHandler do
  @moduledoc """
  A module that handles system shutdowns.

  This module provides a callback-based interface for stopping the system.
  It includes a default implementation of the `stop/0` function that stops
  the system using `System.stop/0`. the purpose of this module is to be able to
  mock the stop call and test console output

  """
  require Logger

  @doc """
  Stops the system.

  This function stops the entire Elixir system, effectively terminating all running
  processes and shutting down the Erlang VM.
  """
  @callback stop() :: :ok
  def stop() do
    System.stop()
  end
end
