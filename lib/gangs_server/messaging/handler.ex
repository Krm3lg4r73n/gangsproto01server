require Logger
alias GangsServer.Messaging

defmodule Messaging.Handler do
  defmacro __using__(_) do
    quote do
      use GenEvent

      def handle_event({:message, message}, _state) do
        Logger.debug inspect(__MODULE__) <> " handling " <> inspect(message)
        handle_message(message.message)
        handle_full_message(message)
        {:ok, nil}
      end

      def handle_message(_), do: :ok
      def handle_full_message(_), do: :ok

      defoverridable [handle_message: 1, handle_full_message: 1]
    end
  end
end
