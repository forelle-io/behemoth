defmodule BehemothWeb.Api.V1.Fishing.FishAccountUserView do
  @moduledoc false

  use BehemothWeb, :view

  def render("show.json", %{fish_account_user: fish_account_user}) do
    %{data: render_one(fish_account_user, __MODULE__, "fish_account_user.json")}
  end

  def render("fish_account_user.json", %{fish_account_user: fish_account_user}) do
    %{
      fish_id: fish_account_user.fish_id,
      user_id: fish_account_user.user_id
    }
  end
end
