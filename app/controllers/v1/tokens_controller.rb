# encoding: UTF-8
class V1::TokensController < Devise::SessionsController
  respond_to :json

  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  skip_before_filter :ensure_tokens_presence, only: [:create]

  def create
    response.headers.merge!({
      'Pragma'        => 'no-cache',
      'Cache-Control' => 'no-store',
    })

    # workaround to avoid the creation of a new warden strategy.
    if params[:email].present? && params[:password].present?

      params['user'] ||= {}
      params['user'].merge!(email: params[:email], password: params[:password])

      # in case token timed out, we should reset it
      if timedout?
        current_user.reset_authentication_token!
      end

      warden.authenticate!(scope: resource_name, store: false)

      render json: { auth_token: current_user.authentication_token }

    else
      render json: {
        errors: 'Missing email or password attribute'
      }, status: :unauthorized
    end

  end

  def destroy
    response.headers.merge!({
      'Pragma'        => 'no-cache',
      'Cache-Control' => 'no-store',
    })

    if current_token = params[:auth_token]
    elsif request.authorization && request.authorization =~ /^Basic (.*)/m
      current_token = Base64.decode64($1).split(/:/, 2)
      current_token = current_token.first
    end

    @user = User.where(authentication_token: current_token).first

    warden.authenticate!(scope: resource_name, store: false)
    current_user.reset_authentication_token!

    render json: '', status: 201
  end

end
