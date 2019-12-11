defmodule BehemothWeb.Api.V1.Fishing.TechniqueAccountUserView do
  @moduledoc false

  use BehemothWeb, :view

  def render("show.json", %{technique_account_user: technique_account_user}) do
    %{data: render_one(technique_account_user, __MODULE__, "technique_account_user.json")}
  end

  def render("technique_account_user.json", %{technique_account_user: technique_account_user}) do
    %{
      technique_id: technique_account_user.technique_id,
      user_id: technique_account_user.user_id
    }
  end
end
