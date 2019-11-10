defmodule KommissarWeb.UserView do
  use KommissarWeb, :view
  alias KommissarWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username}
  end

  def render("token.json", %{token: token, user: user}) do
    %{access_token: token,
      data: render_one(user, UserView, "user.json")}
  end
end
