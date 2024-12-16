defmodule ChatApp.ApplicationTest do
  use ExUnit.Case, async: true

  test "ETS table :messages exists and has correct attributes" do
    assert :ets.whereis(:messages) != :undefined, "ETS table :messages should exist"

    assert :ets.info(:messages, :type) == :bag
    assert :ets.info(:messages, :protection) == :public
  end

  test "Plug.Cowboy is started with correct configuration" do
    children = Supervisor.which_children(ChatApp.Supervisor)

    assert Enum.any?(children, fn
      {{:ranch_listener_sup, ChatApp.Router.HTTP}, _, :supervisor, _} -> true
      _ -> false
    end), "Plug.Cowboy (via Ranch) should be started as a child process"

    assert :ranch.info(ChatApp.Router.HTTP)[:port] == 8002
  end

  test "Supervisor starts children correctly" do
    assert Process.alive?(Process.whereis(ChatApp.Supervisor)), "Supervisor should be running"

    children = Supervisor.which_children(ChatApp.Supervisor)
    assert length(children) > 0, "Supervisor should have at least one child process"
  end

  test "ETS table :messages does not exist if improperly initialized" do
    :ets.delete(:messages)

    assert :ets.whereis(:messages) == :undefined, "ETS table :messages should not exist after deletion"
  end

  test "Plug.Cowboy is not started with an incorrect configuration" do
    children = Supervisor.which_children(ChatApp.Supervisor)

    refute Enum.any?(children, fn
      {{:ranch_listener_sup, :WrongName}, _, :supervisor, _} -> true
      _ -> false
    end), "No Ranch listener should exist with incorrect name"
  end

  test "Ranch listener is not running on incorrect port" do
    refute :ranch.info(ChatApp.Router.HTTP)[:port] == 9000, "Ranch listener should not be running on incorrect port"
  end

end
