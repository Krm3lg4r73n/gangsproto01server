alias GangsServer.{Messaging, Message}

defmodule Messaging.Dictionary do

  @dictionary [
    # SERVER
    {101, Message.Ok},
    {102, Message.Error},
    {103, Message.WorldJoined},
    {104, Message.PlayerUpdate},
    {105, Message.PlayerCreateRequest},

    # CLIENT
    {201, Message.ServerReset},
    {202, Message.User},
    {203, Message.WorldCreate},
    {204, Message.WorldJoin},
    {205, Message.PlayerCreate},

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
