class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_facebook request.env["omniauth.auth"]
    if @user.persisted?
      sign_in_and_redirect @user
    else
      redirect_to root_path
    end
  end

  def google_oauth2
    @user = User.from_google request.env["omniauth.auth"]
    if @user.persisted?
      sign_in_and_redirect @user
    else
      redirect_to root_path
    end
  end
end
