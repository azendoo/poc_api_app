class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :new]

  respond_to :json

  resource_description do
    short 'Users related endpoints'
    formats ['json']

    error 422, "Unprocessable entity"
    error 401, "Unauthorized"
    error 404, "Resource not found"
  end


  # GET /users
  # GET /users.json
  api :GET, "/users", "List users"
  def index
    @users = User.all

    # ugly hack, see :
    # https://github.com/rails-api/active_model_serializers/issues/347
    render json: @users.to_a, :each_serializer => UserSerializer
  end

  # GET /users/1
  # GET /users/1.json
  api :GET, "/users/:id", "Show an user"
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
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  api :PUT, "/users/:id", "Update an user"
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      render json: @user, status: :created, location: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  api :DELETE, "/users/:id", "Delete an user"
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end

  def me
    if current_user
      render json: @current_user
    else
      render status: 401, nothing: true
    end
  end

end
