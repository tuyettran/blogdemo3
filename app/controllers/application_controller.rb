class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.html do
        flash[:danger] = t "layouts.access_denie"
        redirect_to main_app.root_url
      end
    end
  end
end
