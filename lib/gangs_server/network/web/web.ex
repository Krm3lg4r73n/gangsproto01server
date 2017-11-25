require Logger
alias GangsServer.Network

defmodule Network.Web do
  def child_spec(port) do
    Logger.info "Network.Web listening on port #{port}"
    Plug.Adapters.Cowboy.child_spec(:http, :no_plug, [], 
      [ip: {0,0,0,0}, port: port, dispatch: dispatch_config()])
  end

  defp dispatch_config do
    [
      {:_, [
        {"/ws", Network.Web.WebsocketHandler, []},
        {"/health", Plug.Adapters.Cowboy.Handler, {Network.Web.HealthPlug, []}},
        {:_, Plug.Adapters.Cowboy.Handler, {Network.Web.Router, []}}
      ]}
    ]
  end
end