require Logger
alias GangsServer.User

defmodule User.MessageHandler do
  def handle(event, state) do
    Logger.info "=== User handler called STATE: #{inspect(state)}"
    {:cont, state}
  end
end
