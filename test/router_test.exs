defmodule ChatApp.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ChatApp.Router

  @opts Router.init([])

  test "Fallback route returns 404" do
    conn =
      conn(:get, "/non-existent-route")
      |> Router.call(@opts)

    assert conn.status == 404
    assert conn.resp_body == "404 not find."
  end

  test "Route matching with ChatApp.Index" do
    assert Router.route("index") == ChatApp.Index
  end

  test "Route matching with ChatApp.Login" do
    assert Router.route("login") == ChatApp.Login
  end

  test "Route matching with WebSocket path" do
    assert Router.route("/ws/app/login") == ChatApp.Login
  end
end
