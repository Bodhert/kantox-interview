defmodule KantoxMarket.Support.Mocks do
  require Logger
  Mox.defmock(ShutdownHandlerMock, for: ShutdownHandler)
end
