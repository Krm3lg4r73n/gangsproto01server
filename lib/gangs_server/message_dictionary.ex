defmodule GangsServer.MessageDictionary do
  alias GangsServer.Messages

  @dictionary [
    {1, Messages.User},
    {2, Messages.Person}
  ]

  def translate_message(message) do
    {type, _} = Enum.find(@dictionary, fn {_, m} -> m == message.__struct__ end)
    type
  end

  def translate_type(type) do
    {_, message} = Enum.find(@dictionary, fn {t, _} -> t == type end)
    message
  end
end
