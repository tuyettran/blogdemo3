class RegistrationsController < Devise::RegistrationsController
  before_action :configure_params, only: [:create, :edit, :update]

  protected

  def configure_params
    devise_parameter_sanitizer.permit :sign_up,
      keys: [:full_namem, :gender]
    devise_parameter_sanitizer.permit :account_update,
      keys: [:full_name, :gender, :phone_number, :avatar]
  end
end
