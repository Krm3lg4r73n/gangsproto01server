alias GangsServer.{Messaging, Message}

defmodule Messaging.Dictionary do

  @dictionary [
    # SERVER
    {101, Message.Ok},
    {102, Message.Error},
    {103, Message.Bootstrap},

    # CLIENT
    {201, Message.User},
    {202, Message.WorldCreate},
    {203, Message.WorldJoin},

    # OTHER
    {501, Message.Person},
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
