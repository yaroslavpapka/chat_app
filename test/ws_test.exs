defmodule ChatApp.WSTest do
  require N2O
  use ExUnit.Case, async: true
  alias ChatApp.WS

  @moduletag :ws

  describe "init/1" do
    test "initializes with a given module" do
      args = [module: :some_module]
      assert {:ok, _} = WS.init(args)
    end

    test "initializes with no module" do
      args = []
      assert {:ok, _} = WS.init(args)
    end
  end

  describe "handle_in/2" do
    test "responds with PONG to PING" do
      message = {"PING", nil}
      state = %{}
      assert {:reply, :ok, {:text, "PONG"}, ^state} = WS.handle_in(message, state)
    end
  end

  describe "handle_info/2" do
    test "processes an info message correctly" do
      message = :some_message
      state = %{}
      assert {:reply, :ok, {:binary, _}, ^state} = WS.handle_info(message, state)
    end
  end
end
