defmodule KantoxMarket.MixProject do
  use Mix.Project

  def project do
    [
      app: :kantox_market,
      version: "0.1.0",
      elixir: "~> 1.15",
      config_path: "config/config.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # :wx and :observer, :runtime_tools needs to be removed if the machine executing it does not
      # have installed
      extra_applications: [:logger, :wx, :observer, :runtime_tools],
      mod: {KantoxMarket.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_money, "~> 5.0"},
      {:jason, "~> 1.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
