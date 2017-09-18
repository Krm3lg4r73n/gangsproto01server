alias GangsServer.Messaging

defmodule Messaging.Pipeline do
  @handler_pipeline [
    Messaging.LoggerHandler,
    GangsServer.User.MessageHandler,
  ]

  def handle(event, conn_state) do
    @handler_pipeline
    |> Enum.reduce_while(conn_state, fn handler, state ->
      handler.handle(event, state)
    end)
  end
end
