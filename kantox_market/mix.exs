defmodule KantoxMarket.MixProject do
  use Mix.Project

  def project do
    [
      app: :kantox_market,
      version: "0.1.0",
      elixir: "~> 1.15",
      config_path: "config/config.exs",
      start_permanent: Mix.env() == :prod,
      dialyzer: [
        flags: [:error_handling, :no_opaque, :underspecs]
      ],
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: extra_applications(Mix.env()),
      mod: {KantoxMarket.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_money, "~> 5.0"},
      {:jason, "~> 1.0"},
      {:mox, "~> 1.0", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp extra_applications(:prod), do: [:logger]
  defp extra_applications(_), do: [:logger, :wx, :observer, :runtime_tools]
end
