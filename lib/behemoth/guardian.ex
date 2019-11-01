defmodule Behemoth.Guardian do
  @moduledoc false

  use Guardian, otp_app: :behemoth

  alias Behemoth.Contexts.Account
  alias Behemoth.Contexts.Account.User

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, "User:#{id}"}
  end

  def resource_from_claims(%{"sub" => "User:" <> id}) do
    case Account.get_user(id) do
      %User{} = user -> {:ok, user}
      error -> error
    end
  end
end
