use Mix.Config

config :clusterable,
  cookie: :ds,
  app_name: "ds"

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: "ds",
  app_name: "ds",
  log_results: false

config :logger, level: :info
