require Logger
alias GangsServer.TCP

defmodule TCP.Server do
  def listen(port) do
    {:ok, socket} = :gen_tcp.listen(
      port,
      [:binary, {:packet, 0}, active: true, reuseaddr: true])
    Logger.info "TCP.Server listening on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Supervisor.start_child(
      TCP.Connection.Supervisor,
      [client])
    :ok = :gen_tcp.controlling_process(client, pid)

    Process.register(pid, :conn)
    Logger.debug "New connection with pid: #{inspect(pid)}"

    loop_acceptor(socket)
  end
end
