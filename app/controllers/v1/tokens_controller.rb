# encoding: UTF-8
class V1::TokensController < Devise::SessionsController
  respond_to :json

  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  skip_before_filter :check_token_timeout
  skip_before_filter :ensure_token_presence, only: [:create]
  skip_after_filter :update_last_activity, only: [:create]

  def create
    if credentials_present?
      params['user'] ||= {}
      params['user'].merge!(email: params[:email], password: params[:password])

      warden.authenticate!(scope: resource_name, store: false)

      current_user.reset_authentication_token! if timedout?

      render json:
      {
        auth_token: current_user.authentication_token
      }, status: :ok
    else
      render json:
      {
        errors: 'Missing email or password attribute'
      }, status: :unauthorized
    end
  end

  def destroy
    current_token ||= params[:auth_token]
    if authorization_present?
      current_token = Base64.decode64($1).split(/:/, 2)
      current_token = current_token.first
    end

    @user = User.where(authentication_token: current_token).first

    warden.authenticate!(scope: resource_name, store: false)
    current_user.reset_authentication_token!

    head :ok
  end

  private
  def credentials_present?
    params[:email].present? && params[:password].present?
  end

  def authorization_present?
    request.authorization.present? && request.authorization =~ /^Basic (.*)/m
  end
end
