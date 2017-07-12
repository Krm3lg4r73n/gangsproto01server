alias GangsServer.{Messaging, Message}

defmodule Messaging.Dictionary do

  @dictionary [
    {1, Message.User},
    {2, Message.Person}
  ]

  def dict, do: @dictionary

  def translate_message(message) do
    {type, _} = Enum.find(@dictionary, fn {_, m} -> m == message.__struct__ end)
    type
  end

  def translate_type(type) do
    {_, message} = Enum.find(@dictionary, fn {t, _} -> t == type end)
    message
  end
end
