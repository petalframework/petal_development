defmodule AppWeb.Router do
  use AppWeb, :router

  import AppWeb.UserAuth
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {AppWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
    plug(AppWeb.RobotsPlug)
  end

  scope "/", AppWeb do
    pipe_through([:browser])

    # Any static pages go here
    scope "/", PublicLive do
      live("/", LandingPage, :index)
      live("/faq", FaqPage, :index)
      live("/privacy", PrivacyPage, :index)
      live("/about", AboutPage, :index)
      live("/contact", ContactPage, :index)
      live("/terms", TermsPage, :index)
    end
  end

  # Redirects if you're authenticated
  scope "/", AppWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])
    post("/users/token-sign-in", UserSessionController, :token_sign_in)

    # Password auth
    scope "/auth/with-password", AuthLive do
      live "/register", Password, :register
      live "/sign-in", Password, :sign_in
      live "/signing-in", Password, :signing_in
      live "/reset-password", Password.ResetPassword, :index
      live "/set-new-password/:token", Password.SetNewPassword, :index
    end

    # Passwordless auth
    scope "/auth/passwordless", AuthLive do
      live("/sign-in", Passwordless, :sign_in)
      live("/sign-in-code/:user_id", Passwordless, :sign_in_code)
      live("/register", Passwordless, :register)
    end

    get("/confirm/:id/:pin", UserSettingsController, :confirm_quick_register)
  end

  # Authenticated users only
  scope "/", AppWeb do
    pipe_through([:browser, :require_authenticated_user])

    live("/sign-out", AuthLive.SignOut)
    get("/instant-sign-out", UserSessionController, :delete)

    live("/private", PrivateLive.PrivatePageExample, :index)

    scope "/u/settings" do
      put("/update_password", UserSettingsController, :update_password)
      get("/confirm_email/:token", UserSettingsController, :confirm_email)
    end

    scope "/u/:id" do
      pipe_through([:can_edit_user?])

      delete("/delete_user", UserSettingsController, :delete_user)

      scope "/edit", UserLive do
        live("/", Edit, :index)
        live("/notifications", Edit, :notifications)
        live("/change_email", Edit, :change_email)
        live("/change_password", Edit, :change_password)
      end
    end
  end

  # Moderators only
  scope "/moderate", AppWeb.ModerateLive do
    pipe_through([:browser, :require_moderator_user])

    live("/logs", Logs, :index)
    live("/users", Users, :index)
    live_dashboard("/server", metrics: AppWeb.Telemetry)
  end

  if Mix.env() == :dev do
    scope "/dev" do
      forward("/sent_emails", Bamboo.SentEmailViewerPlug)

      scope "/emails" do
        pipe_through([:browser, :require_authenticated_user])

        get("/", AppWeb.EmailTestingController, :index)
        get("/preview/:email_name", AppWeb.EmailTestingController, :preview)
        post("/send_test_email/:email_name", AppWeb.EmailTestingController, :send_test_email)
        get("/show/:email_name", AppWeb.EmailTestingController, :show_html)
      end
    end
  end
end
