alias GangsServer.{Messaging, Message}

defmodule Messaging.Dictionary do

  @dictionary [
    # SERVER
    {101, Message.WorldJoined},
    {102, Message.PlayerUpdate},
    {103, Message.PlayerCreateRequest},
    {104, Message.PlayerSelectRequest},
    {105, Message.LocationUpdate},

    # CLIENT
    {201, Message.ServerReset},
    {202, Message.User},
    {203, Message.WorldCreate},
    {204, Message.WorldJoin},
    {205, Message.PlayerCreate},
    {205, Message.PlayerSelect},

    # COMMON
    {501, Message.Ping},
    {502, Message.Pong},
    {503, Message.Ok},
    {504, Message.Error},
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
