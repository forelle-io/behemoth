defmodule BehemothWeb.PageView do
  @moduledoc false

  use BehemothWeb, :view

  def application_name do
    :otp_app
    |> BehemothWeb.Endpoint.config()
    |> Atom.to_string()
    |> String.capitalize()
  end
end
