class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if request.env["omniauth.auth"].info.email.present?
      @user = User.from_facebook request.env["omniauth.auth"]
      if @user.persisted?
        sign_in_and_redirect @user
      else
        redirect_to root_path
      end
    else
      flash[:danger] = t "devise.sessions.new.lose_email_info"
      redirect_back
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
