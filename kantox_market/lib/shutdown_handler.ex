defmodule ShutdownHandler do
  require Logger
  @callback stop() :: :ok
  def stop() do
    System.stop()
  end
end
