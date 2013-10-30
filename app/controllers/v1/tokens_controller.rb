# encoding: UTF-8
class V1::TokensController < Devise::SessionsController
  respond_to :json

  before_filter :ensure_credentials_presence, only: [:create]

  skip_before_filter :ensure_token_presence, only: [:create]
  skip_before_filter :authenticate_user_from_token!, only: [:create]
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  skip_before_filter :check_token_timeout
  skip_after_filter :update_last_activity, only: [:create]

  # XXX :
  # I guess that authentication should be entirely done by the OAuth Provider.
  # That method was the beginning of a version based on Doorkeeper's access_token.
  # It should be updated or removed.
  def create
    authenticate_from_credentials!(params[:email], params[:password])

    if current_user.nil?
      render json: {
        errors: 'Invalid email or password'
      }, status: :unauthorized
    else
      token_infos = current_user.access_tokens.first
      render json: {
        token: token_infos.token,
        expires_in: token_infos.expires_in
      }, status: :ok
    end
  end

  # XXX :
  # Old Devise version.
  # Should reset Doorkeeper access token using the refresh token.
  # Except if everything related to authentication is now on our Provider...
  def destroy
    current_token = fetch_token(request)

    current_user = User.where(authentication_token: current_token).first
    current_user = warden.authenticate!(scope: :user, store: false)

    if current_user
      current_user.reset_authentication_token!
      head :ok
    end
  end

end
