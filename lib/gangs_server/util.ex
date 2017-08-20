alias GangsServer.{Message, User, Messaging}

defmodule GangsServer.Util do
  def stringify_changeset_errors(changeset) do
    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    Poison.encode!(errors)
  end

  def send_user_error(user_pid, error_desc) do
    Message.Error.new(type: "ClientError", description: error_desc)
    |> User.Message.send(user_pid)
  end

  def send_user_ok(user_pid) do
    Message.Ok.new()
    |> User.Message.send(user_pid)
  end

  def send_conn_error(conn_pid, error_desc) do
    Message.Error.new(type: "ClientError", description: error_desc)
    |> Messaging.Message.send(conn_pid)
  end

  def send_conn_ok(conn_pid) do
    Message.Ok.new()
    |> Messaging.Message.send(conn_pid)
  end
end
