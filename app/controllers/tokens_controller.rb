class TokensController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    if @user = User.first(conditions: {email: params[:user][:email]})
      @user.ensure_authentication_token!

      if @user.valid_password?(params[:user][:password])
        render json: {
          auth_token: resource.reset_authentication_token,
          user_role: resource.role
        }
      else
        render json: {errors: @user.errors}, status: 401
      end
    else
      return
    end

    render json: {errors:"Invalid login credentials"}, status: 401

  end

  def destroy
    sign_out(resource_name)
    render json: {message: "token detroyed"}, status: 201
  end

end
