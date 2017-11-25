require Logger
alias GangsServer.Network

defmodule Network.Web.HealthPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    Logger.debug "Health check"
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Ok")
  end
end