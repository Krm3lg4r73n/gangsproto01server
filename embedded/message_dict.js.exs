Code.require_file "../lib/gangs_server/messaging/dictionary.ex", __DIR__

defmodule Messages do
  def generate do
    GangsServer.Messaging.Dictionary.dict
    |> Enum.map(fn {id, module} ->
      {id, stringify_module(module)}
    end)
  end

  defp stringify_module(module) do
    module
    |> to_string
    |> String.split(".")
    |> Enum.drop(3) #Elixir.GenServer.Message
    |> Enum.join(".")
  end
end

IO.write EEx.eval_file("embedded/message_dict.js.eex", [
  messages: Messages.generate,
])
