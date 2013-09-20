# encoding: UTF-8
class V1::UsersController < ApplicationController
  respond_to :json

  skip_before_filter :authenticate_user!, only: [:create, :new]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    render json: @users
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
    @user = User.new(resource_params)

    if @user.save
      render json: @user, status: :created, location: user_url(@user)
    else
      render json: {
        errors: @user.errors
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(resource_params)
      render json: @user, status: :created, location: user_url(@user)
    else
      render json: {
        errors: @user.errors
      }, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :ok
  end

  # GET /users/me
  # GET /users/me.json
  def me
    if current_user
      render json: current_user
    else
      render json: { errors: 'Not Authorized.' }, status: 401
    end
  end

  private

  def resource_params
    params.permit(:id, :email, :password)
  end
end
