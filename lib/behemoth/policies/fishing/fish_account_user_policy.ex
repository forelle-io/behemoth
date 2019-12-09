defmodule Behemoth.Policies.Fishing.FishAccountUserPolicy do
  @moduledoc false

  @behaviour Bodyguard.Policy

  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing.FishAccountUser

  def authorize(:delete, %User{id: id}, %FishAccountUser{user_id: id}), do: true

  def authorize(_, _, _), do: false
end
