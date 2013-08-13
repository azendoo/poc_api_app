# encoding: UTF-8
class Api::V2::UsersController < Api::V1::UsersController

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    render json: @user, serializer: UserSerializer, version: :v2
  end

end
