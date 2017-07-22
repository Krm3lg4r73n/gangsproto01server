defmodule GangsServer.Message do
  use Protobuf, from: Path.wildcard(Path.expand("./protobufs/**/*.proto"))

  defstruct [:message, :conn]
end
