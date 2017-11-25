alias GangsServer.Network

defmodule Network.Web.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/api" do
    send_resp(conn, 200, "API here")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end