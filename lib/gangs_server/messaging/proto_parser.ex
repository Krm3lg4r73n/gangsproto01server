alias GangsServer.Messaging

defmodule Messaging.ProtoParser do
  def parse(type, data) do
    proto_msg = Messaging.Dictionary.translate_type(type)
    proto_msg.decode(data)
  end
end
