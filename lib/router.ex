defmodule ChatApp.Router do
  require N2O
  use Plug.Router

  plug Plug.Static, at: "/app", from: :chat_app
  plug Plug.Static, at: "/", from: :chat_app

  plug :match
  plug :dispatch

  def init(state, context) do
    %{path: path} = N2O.cx(context, :req)
    {:ok, state, N2O.cx(context, path: path, module: ChatApp.Router.route(path))}
  end

  def finish(state, ctx), do: {:ok, state, ctx}

  def route(<<"/ws/app/", p::binary>>), do: route(p)
  def route(<<"index", _::binary>>), do: ChatApp.Index
  def route(<<"login", _::binary>>), do: ChatApp.Login

  get "/ws/app/:mod" do
    conn
    |> WebSockAdapter.upgrade(ChatApp.WS, [module: extract(mod)], timeout: 60_000)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "404 not find.")
  end

  defp extract(route), do: route(route)
end
