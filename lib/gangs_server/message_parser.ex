defmodule GangsServer.MessageParser do
  def parse(type, data) do
    case type do
      1 -> GangsServer.Messages.User.decode(data)
      2 -> GangsServer.Messages.Person.decode(data)
    end
    |> GangsServer.MessageHandler.handle
  end
end
