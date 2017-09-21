require Logger
alias GangsServer.Messaging

defmodule Messaging.Handler.Log do
  def handle(event, state) do
    Logger.info """
    MESSAGING-PIPELINE-LOG
    ---PIPELINE-EVENT: #{inspect(event)}
    ---PIPELINE-STATE: #{inspect(state)}
    """
    {:cont, state}
  end
end
