require Logger
alias GangsServer.{Messaging, Message, Store}

defmodule Messaging.Handler do
  def handle(%Message.User{name: name}) do
    Logger.info "User '#{name}' connected"
  end

  def handle(%Message.Person{name: name}) do
    %Store.Person{}
    |> Store.Person.changeset(%{name: name})
    |> Store.Repo.insert!
  end

  def handle(_), do: :ok
end
