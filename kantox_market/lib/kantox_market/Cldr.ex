defmodule KantoxMarket.Cldr do
  @moduledoc """
  Configuration for internationalization and localization for ex_money
  """
  use Cldr,
    locales: ["en"],
    default_locale: "en",
    providers: [Cldr.Number, Money]
end
