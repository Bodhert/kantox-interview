import Config

config :ex_money, default_cldr_backend: KantoxMarket.Cldr

config :kantox_market,
  shut_down_handler: ShutdownHandler

if config_env() == :test do
  config :kantox_market,
    shut_down_handler: ShutdownHandlerMock
end
