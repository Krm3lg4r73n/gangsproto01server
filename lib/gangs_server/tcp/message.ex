alias GangsServer.TCP

defmodule TCP.Message do
  defstruct [:type, :data, :connection]
end
