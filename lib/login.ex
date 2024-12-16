defmodule ChatApp.Login do
  require NITRO
  require Logger

  def event(:init) do
    Enum.each(1..3, fn i ->
      room = "Room#{i}"
      :nitro.insert_top(:main, NITRO.button(id: String.to_atom("room#{i}Button"), body: room, postback: {:join_room, room}))
    end)
  end

  def event({:join_room, room}) do
    user = "user_#{:crypto.strong_rand_bytes(4) |> Base.encode16()}"
    :n2o.user(user)
    :n2o.session(:room, room)
    :nitro.redirect(["/app/index.htm?", room])
  end

  def event(unexpected), do: unexpected |> inspect() |> Logger.warning()
end
