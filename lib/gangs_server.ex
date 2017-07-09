require Logger

defmodule GangsServer do
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(
      port,
      [:binary, {:packet, 0}, active: true, reuseaddr: true])
    Logger.info "Server listening on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Supervisor.start_child(
      GangsServer.Connection.Supervisor,
      [client])
    :ok = :gen_tcp.controlling_process(client, pid)

    Process.register(pid, :conn)
    Logger.debug "New connection with pid: #{inspect(pid)}"

    loop_acceptor(socket)
  end
end
