class SessionsController < Devise::SessionsController
  include Devise::Controllers::Helpers

  prepend_before_filter :require_no_authentication, :only => [:create]
  before_filter :ensure_params_exist
  respond_to :json

  def create
    build_resource
    resource = User.find_for_database_authentication(:email=>params[:user][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])

      sign_in(resource_name, resource)
      render json: {
        success: true,
        auth_token: resource.authentication_token,
        email: resource.email,
        name: resource.name
      }
      return
    end
    invalid_login_attempt
  end

  def destroy
    resource.reset_authentication_token!
    sign_out(resource_name)
  end

  protected
  def ensure_params_exist
    return unless params[:user][:email].blank?
    render json: {
      success: false,
      message: "Missing parameters."
    }, status: 422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: {
      success: false,
      message: "Invalid email or password."
    }, status: 401
  end
end
