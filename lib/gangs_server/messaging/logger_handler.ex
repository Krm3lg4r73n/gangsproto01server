require Logger
alias GangsServer.Messaging

defmodule Messaging.LoggerHandler do
  def handle(event, state) do
    Logger.info "---PIPELINE-EVENT: #{inspect(event)}"
    Logger.info "---PIPELINE-STATE: #{inspect(state)}"
    {:cont, state}
  end
end

