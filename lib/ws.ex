defmodule ChatApp.WS do
  require N2O

  def init(args) do
    module = Keyword.get(args, :module)
    {:ok, N2O.cx(module: module)}
  end

  def handle_in({"N2O," <> _ = message, _}, state), do: stream_response(:text, message, state)
  def handle_in({"PING", _}, state), do: {:reply, :ok, {:text, "PONG"}, state}
  def handle_in({message, _}, state) when is_binary(message), do: stream_response(:binary, message, state)

  def handle_info(message, state), do: process_info(message, state)

  defp stream_response(type, message, state) do
    :n2o_proto.stream({type, message}, [], state)
    |> build_response()
  end

  defp process_info(message, state) do
    :n2o_proto.info(message, [], state)
    |> build_response()
  end

  defp build_response({:reply, {format, data}, _, state}) do
    {:reply, :ok, encode_response(format, data), state}
  end

  defp encode_response(:binary, data), do: {:binary, data}
  defp encode_response(:text, data), do: {:text, data}
  defp encode_response(:bert, data), do: {:binary, :n2o_bert.encode(data)}
  defp encode_response(:json, data), do: {:binary, :n2o_json.encode(data)}
  defp encode_response(_, data), do: {:text, "Unsupported format: #{inspect(data)}"}
end
