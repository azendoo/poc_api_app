class TokensController < Devise::SessionsController
  include Devise::Controllers::Helpers
  skip_before_filter :authenticate_user!, :only => [:create]
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    #    if @user = User.where(email: params[:user][:email]).first
    #      @user.ensure_authentication_token!
    #      if @user.valid_password?(params[:user][:password])
    #        render json: { auth_token: @user.authentication_token }
    #      else
    #        render json: { errors: @user.errors }, status: 401
    #      end
    #    else
    #      render json: { errors:"Invalid login credentials." }, status: 401
    #    end
    #
    warden.authenticate!(:scope => resource_name, :store => false)
    render json: { auth_token: current_user.authentication_token }
  end

  def destroy
    #    @user = User.where(authentication_token: params[:auth_token]).first
    #    if @user.nil?
    #      render json: { errors: "Can't find this token." }
    #    else
    #      binding.pry
    #      @user.reset_authentication_token!
    #      render json: { data: { auth_token: @user.authentication_token} }, status: 201
    #    end
    warden.authenticate!(:scope => resource_name, :store => false)
    current_user.reset_authentication_token!

    response.header['Cache-Control'] = 'no-cache'
    render json: '', status: 201
  end

  #  protected
  #  def ensure_params_exist
  #    return unless params[:user].blank?
  #    render json: { errors: "Missing user parameters (email and password required)." }, status: 422
  #  end
end
