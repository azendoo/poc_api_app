# encoding: UTF-8
class V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  include Devise::Controllers::Helpers

  skip_before_filter :authenticate_user!, :check_token_timeout
  skip_before_filter :ensure_tokens_presence
  skip_after_filter :update_last_activity

  resource_description do
    resource_id 'users'
  end

  # POST /users
  # POST /users.json
  api :POST, '/users', 'Create a user'
  param :user, Hash do
    param :email, String, desc: 'User\'s email address', required: true
    param :password, String, desc: 'User\'s password', required: true
  end
  error code: 422
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
