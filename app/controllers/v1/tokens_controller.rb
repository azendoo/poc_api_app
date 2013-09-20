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

  def create
      authenticate_from_credentials!(params[:email], params[:password])

      if !current_user.nil?
        render json: { auth_token: current_user.authentication_token },
          status: :ok
      else
        render json: { errors: 'Invalid email or password' },
          status: :unauthorized
      end
  end

  def destroy
    # since we are dealing with a devise controller
    # we can't use 'authenticate_user!' method, thus
    # we must directly call warden.authenticate :

    current_token = fetch_token(request)

    current_user = User.where(authentication_token: current_token).first
    current_user = warden.authenticate!(scope: :user, store: false)

    if current_user
      current_user.reset_authentication_token!
      head :ok
    end
  end

  private

  def resource_params
    params.permit(:email, :password)
  end
end
