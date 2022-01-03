defmodule MatchmakerWeb.Router do
  use MatchmakerWeb, :router

  import MatchmakerWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MatchmakerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Authentication routes

  scope "/", MatchmakerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", MatchmakerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :default, on_mount: MatchmakerWeb.UserLiveAuth do
      live "/", MatchSessionLive.Index, :index

      live "/sessions", MatchSessionLive.Index, :index
      live "/sessions/new", MatchSessionLive.Index, :new
      live "/sessions/:id/edit", MatchSessionLive.Index, :edit

      live "/sessions/:id", MatchSessionLive.Show, :show
      live "/sessions/:id/show/edit", MatchSessionLive.Show, :edit
    end

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", MatchmakerWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
