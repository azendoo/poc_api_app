# encoding: UTF-8
class V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  include Devise::Controllers::Helpers

  skip_before_filter :authenticate_user!
  skip_before_filter :check_token_timeout
  skip_before_filter :ensure_token_presence
  skip_after_filter :update_last_activity

  # POST /users
  # POST /users.json
  def create

    if params[:email].present? && params[:password].present?

      params['user'] ||= {}
      params['user'].merge!(email: params[:email], password: params[:password])

      user = User.new(params[:user])

      if user.save
        render json: {
          email: user.email,
          auth_token: user.authentication_token
        }, status: 201
        return
      else
        clean_up_passwords user
        render  json: {
          errors: user.errors
        }, status: :unprocessable_entity
      end

    else
      render json: {
        errors: 'Missing email or password attribute'
      }, status: :bad_request
    end

  end
end
