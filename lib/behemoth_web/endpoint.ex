defmodule BehemothWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :behemoth

  socket "/socket", BehemothWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static, at: "/", from: :behemoth, gzip: false, only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_behemoth_key",
    signing_salt: "o5PZVsYq"

  # Cross-Origin Resource Sharing
  if Mix.env() == :dev do
    plug CORSPlug,
      origin: ~r/^https?:\/\/(localhost|127.0.0.1|192.168.232.3):300(0|1)$/
  end

  plug BehemothWeb.Router
end
