# encoding: UTF-8
class V2::UsersController < V1::UsersController
  respond_to :json

  # GET /users
  # GET /users.json
  def index
    @user = User.all

    # Just added a strange behavior for
    # versioning purpose ...
    render json: @user.last
  end

end
