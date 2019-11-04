defmodule Behemoth.Policies.Account.UserPolicy do
  @moduledoc false

  @behaviour Bodyguard.Policy

  alias Behemoth.Contexts.Account.User

  def authorize(action, %User{id: id}, %User{id: id})
      when action in [:show, :update, :delete],
      do: true

  def authorize(_, _, _), do: false
end
