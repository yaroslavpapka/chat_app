defmodule ChatApp.Login do
  require NITRO
  require Logger

  def event(:init) do
    :nitro.insert_top(:main, NITRO.button(id: :room3Button, body: "Room3", postback: {:join_room, "room3"}))
    :nitro.insert_top(:main, NITRO.button(id: :room2Button, body: "Room2", postback: {:join_room, "room2"}))
    :nitro.insert_top(:main, NITRO.button(id: :room1Button, body: "Room1", postback: {:join_room, "room1"}))
  end

  def event({:join_room, room}) do
    user = "user_#{:crypto.strong_rand_bytes(4) |> Base.encode16()}"
    :n2o.user(user)
    :n2o.session(:room, room)
    :nitro.redirect(["/app/index.htm?", room])
  end

  def event(unexpected), do: unexpected |> inspect() |> Logger.warning()
end
