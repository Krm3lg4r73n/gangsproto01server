require Logger
alias GangsServer.Messaging

defmodule Messaging.Handler.Log do
  def handle(event, state) do
    Logger.info """
    MESSAGING-PIPELINE
    ---EVENT: #{inspect(event)}
    ---STATE: #{inspect(state)}
    """
    :cont
  end
end
