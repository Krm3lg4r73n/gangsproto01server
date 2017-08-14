alias GangsServer.{Game, User}

defmodule Game.Systems do
  def attach_user_process(user_pid) do
    User.Process.attach_to_system(user_pid, Game.System.World)
  end
end
