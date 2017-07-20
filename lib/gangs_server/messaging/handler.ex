require Logger
alias GangsServer.{Messaging, Message, Store}

defmodule Messaging.Handler do
  use GenEvent

  def handle_event({:message, message}, _) do
    handle_message(message)
    {:ok, nil}
  end

  # defp handle_message(%Message.User{name: name}) do
  #   Logger.info "User '#{name}' connected"
  # end
  # defp handle_message(%Message.Person{name: name}) do
  #   %Store.Person{}
  #   |> Store.Person.changeset(%{name: name})
  #   |> Store.Repo.insert!
  # end
  defp handle_message(_), do: :ok
end
