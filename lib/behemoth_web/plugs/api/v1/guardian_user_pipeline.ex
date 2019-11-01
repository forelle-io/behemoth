defmodule BehemothWeb.Plugs.Api.V1.GuardianUserPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :behemoth,
    error_handler: BehemothWeb.GuardianErrorHandler,
    module: Behemoth.Guardian

  plug Guardian.Plug.VerifyHeader, key: :user, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, key: :user, allow_blank: true
end
