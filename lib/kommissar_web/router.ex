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

  scope "/", KommissarWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", KommissarWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end
end
