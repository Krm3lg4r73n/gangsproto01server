alias GangsServer.{Game, User}

defmodule Game.UserSystems do
  def attach_user_process(user_pid) do
    User.Process.attach_to_system(user_pid, Game.UserSystem.World)
    User.Process.attach_to_system(user_pid, Game.UserSystem.Logger)
  end
end
