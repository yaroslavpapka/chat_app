defmodule ChatApp.Index do
  require NITRO
  require N2O

  def event(:init) do
    case :n2o.session(:room) do
      [] -> handle_empty_room()
      room -> initialize_room(room)
    end
  end

  def event(:logout) do
    :n2o.user([])
    :nitro.redirect("/app/login.htm")
  end

  def event(:chat), do: chat(:nitro.q(:message))

  def event({:client, {user, message, timestamp}}) do
    render_message(user, message, timestamp)
  end

  def event(_), do: :ok

  defp handle_empty_room do
    :nitro.redirect("/app/login.htm")
  end

  defp initialize_room(room) do
    :n2o.reg({:topic, room})
    update_ui(room)
    load_and_render_messages(room)
  end

  defp update_ui(room) do
    :nitro.update(:heading,
      NITRO.h2(id: :heading, body: room)
    )

    :nitro.update(:message,
      NITRO.textarea(id: :message, rows: 3, class: "chat-textarea", placeholder: "Enter your message...")
    )

    :nitro.update(:logout,
      NITRO.button(id: :logout, postback: :logout, body: "Logout")
    )

    :nitro.update(:send,
      NITRO.button(id: :send, body: "Send", postback: :chat, source: [:message])
    )

    :nitro.insert_top(:body,
      NITRO.div(id: :upload_section,
        body: [
          NITRO.input(type: :file, id: :photo, accept: "image/*"),
          NITRO.button(id: :upload, body: "Upload Photo", postback: :upload_photo, source: [:photo])
        ]
      )
    )
  end

  defp load_and_render_messages(room) do
    :ets.lookup(:messages, room)
    |> Enum.each(fn {_room, user, message, timestamp} ->
      event({:client, {user, message, timestamp}})
    end)
  end

  defp render_message(user, message, timestamp) do
    content =
      case String.ends_with?(message, [".jpg", ".png", ".jpeg"]) do
        true -> NITRO.image(src: message, class: "chat-image")
        _ -> :nitro.jse(message)
      end

    :nitro.insert_top(
      :history,
      NITRO.message(
        body: [
          NITRO.author(body: user),
          content,
          NITRO.span(class: "timestamp", body: timestamp)
        ]
      )
    )
  end

  def chat(message) do
    room = :n2o.session(:room)
    user = :n2o.user()
    timestamp = current_timestamp()

    store_message(room, user, message, timestamp)
    broadcast_message(room, user, message, timestamp)
    :nitro.update(:message, NITRO.textarea(id: :message, body: ""))
  end

  defp current_timestamp do
    DateTime.utc_now()
    |> DateTime.add(2 * 3600, :second)
    |> DateTime.truncate(:second)
    |> DateTime.to_string()
  end

  defp store_message(room, user, message, timestamp) do
    :ets.insert(:messages, {room, user, message, timestamp})
  end

  defp broadcast_message(room, user, message, timestamp) do
    :n2o.send({:topic, room}, N2O.client(data: {user, message, timestamp}))
  end

  def handle_upload(conn) do
    case conn.params["photo"] do
      %Plug.Upload{filename: filename, path: temp_path} ->
        upload_dir = "uploads"
        File.mkdir_p!(upload_dir)
        file_path = Path.join(upload_dir, filename)

        case File.cp(temp_path, file_path) do
          :ok ->
            {:ok, file_path}

          error ->
            {:error, error}
        end

      _ ->
        {:error, "Invalid upload"}
    end
  end

end
