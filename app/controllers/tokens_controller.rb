class TokensController < Devise::SessionsController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  skip_before_filter :ensure_tokens_presence, :only => [:create]
  skip_after_filter :update_last_activity, :only => [:create]

  respond_to :json

  def create
    response.headers.merge!({
      'Pragma'        => 'no-cache',
      'Cache-Control' => 'no-store',
    })

    # workaround to avoid the creation of a new warden strategy.
    if params[:email].present? && params[:password].present?

      params["user"] ||= {}
      params["user"].merge!(email: params[:email], password: params[:password])

      warden.authenticate!(:scope => resource_name, :store => false)

      render json: { auth_token: current_user.authentication_token }
    else
      render json: { errors: "Missing email or password attribute" }, status: :unauthorized
    end

  end

  # XXX : currently reset authentication token, maybe we should
  # directly return the new token.
  def destroy
    response.headers.merge!({
      'Pragma'        => 'no-cache',
      'Cache-Control' => 'no-store',
    })

    warden.authenticate!(:scope => resource_name, :store => false)
    current_user.reset_authentication_token!

    render json: '', status: 201
  end

end
