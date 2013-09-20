# encoding: UTF-8
class V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  include Devise::Controllers::Helpers

  before_filter :ensure_credentials_presence

  skip_before_filter :authenticate_user_from_token!
  skip_before_filter :authenticate_user!
  skip_before_filter :check_token_timeout
  skip_before_filter :ensure_token_presence
  skip_after_filter :update_last_activity

  # POST /users
  # POST /users.json
  def create
    u = User.new(resource_params)

    if u.save!
      render json: { email: u.email, auth_token: u.authentication_token },
        status: :created
    else
      clean_up_passwords u
      render  json: { errors: u.errors }, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.permit(:email, :password)
  end
end
