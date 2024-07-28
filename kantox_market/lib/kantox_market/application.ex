defmodule KantoxMarket.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KantoxMarket.Supervisor,
      {Task, fn -> KantoxMarket.prompt_console() end}
    ]

    opts = [strategy: :one_for_one, name: KantoxMarket.Application]
    Supervisor.start_link(children, opts)
  end
end
