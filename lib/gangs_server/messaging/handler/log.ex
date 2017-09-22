require Logger
alias GangsServer.Messaging

defmodule Messaging.Handler.Log do
  def handle(event, state) do
    Logger.info "MESSAGING-PIPELINE\n---EVENT: #{inspect(event)}\n---STATE: #{inspect(state)}"
    :cont
  end
end
