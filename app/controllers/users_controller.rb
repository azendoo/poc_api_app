class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :new]

  respond_to :json

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    # ugly hack, see :
    # https://github.com/rails-api/active_model_serializers/issues/347
    render json: @users.to_a, :each_serializer => UserSerializer
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    render json: @user
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end

  private
  def resource_params
    params.require(:user).permit(
      :email, :password,
      :password_confirmation, :remember_me
    )
  end
end
