defmodule KommissarWeb.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :kommissar,
    module: KommissarWeb.Guardian,
    error_handler: KommissarWeb.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader, key: :impersonate
    plug Guardian.Plug.EnsureAuthenticated, key: :impersonate
    plug Guardian.Plug.LoadResource, allow_blank: true, key: :impersonate
end

defmodule KommissarWeb.Router do
  use KommissarWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected_api do
    plug :accepts, ["json"]
    plug KommissarWeb.AuthAccessPipeline
  end

  scope "/", KommissarWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", KommissarWeb do
    pipe_through :protected_api

    get "/users/me", UserController, :me
  end
  scope "/api", KommissarWeb do
    pipe_through :api

    post "/users/login", UserController, :login
    resources "/users", UserController, except: [:new, :edit]
  end
end
