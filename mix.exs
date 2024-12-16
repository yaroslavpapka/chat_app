defmodule ChatApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :chat_app,
      version: "0.1.0",
      elixir: "~> 1.16",
      deps: deps()
    ]
  end

  def application() do
    [
      mod: {ChatApp.Application, []},
      extra_applications: [:logger]
    ]
  end

  def deps() do
    [
      {:plug, "~> 1.15.3"},
      {:bandit, "~> 1.0"},
      {:plug_cowboy, "~> 2.7"},
      {:websock_adapter, "~> 0.5"},
      {:nitro, "~> 9.9"},
      {:n2o, "~> 11.9"},
      {:syn, "~> 2.1.1"},
      {:mox, "~> 1.0", only: :test},
      {:jason, "~> 1.4"}
    ]
  end
end
