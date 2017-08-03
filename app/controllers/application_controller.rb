class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :redirect_back

  def redirect_back(options = {})
    if request.referer
      redirect_to request.referer, options
    else
      redirect_to root_path, options
    end
  end

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.html do
        flash[:danger] = t "layouts.access_denie"
        redirect_to main_app.root_url
      end
    end
  end
end
