alias GangsServer.Store
alias Store.Schema.Line

defmodule Store.Interactor.Line do
  import Ecto.Query

  def localize(user_id, key) do
    case Store.Interactor.User.get_by_id(user_id) do
      nil -> nil
      user -> Store.Repo.one(
          from l in Line,
          where: l.locale_ref == ^user.locale_ref and l.key == ^key,
          select: l.text
        )
    end
  end
end
