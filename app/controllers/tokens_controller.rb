class TokensController < Devise::SessionsController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    warden.authenticate!(:scope => resource_name, :store => false)
    render json: { auth_token: current_user.authentication_token }
  end

  # TODO :
  def destroy
    response.header['Cache-Control'] = 'no-cache'
    render json: '', status: 201
  end

end
