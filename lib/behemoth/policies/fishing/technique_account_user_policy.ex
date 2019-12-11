defmodule Behemoth.Policies.Fishing.TechniqueAccountUserPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing.TechniqueAccountUser

  # credo:disable-for-lines:15 Credo.Check.Refactor.PipeChainStart
  def authorize(:create, %User{id: id}, %{"user_id" => user_id}) do
    if is_integer(user_id) do
      user_id
    else
      String.to_integer(user_id)
    end
    |> Kernel.==(id)
  rescue
    ArgumentError -> false
  end

  def authorize(:delete, %User{id: id}, %TechniqueAccountUser{user_id: id}), do: true

  def authorize(_, _, _), do: false
end
