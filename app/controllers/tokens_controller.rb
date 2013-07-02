class TokensController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:create]
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    if @user = User.first(conditions: {email: params[:user][:email]})
      @user.ensure_authentication_token!

      if @user.valid_password?(params[:user][:password])
        render json: { auth_token: @user.authentication_token }
      else
        render json: { errors: @user.errors }, status: 401
      end
    else
      render json: { errors:"Invalid login credentials" }, status: 401
    end

  end

  def destroy
    @user = User.first(conditions: { authentication_token: params[:id] })
    if @user.nil?
      render json: { errors: "User doesn't exists." }
    else
      @user.reset_authentication_token!
      render json: { message: "token detroyed" }, status: 201
    end
  end

end
