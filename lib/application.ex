defmodule ChatApp.Application do
  use Application

  def start(_, _) do
    :ets.new(:messages, [:named_table, :bag, :public])
    children = [
      {Plug.Cowboy, scheme: :http, port: 8002, plug: ChatApp.Router}
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: ChatApp.Supervisor)
  end
end
