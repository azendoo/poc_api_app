# encoding: UTF-8
class V2::UsersController < V1::UsersController
  respond_to :json

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    render json: @user
  end

end
