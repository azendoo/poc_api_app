# encoding: UTF-8
class V1::TasksController < ApplicationController
  respond_to :json

  include ActionController::MimeResponds

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

    render json: @tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    render json: @task
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new

    render json: @task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(resource_params)
    @task.user_id = current_user.id

    if @task.save
      render json: @task, status: :created, location: task_url(@task)
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(resource_params)
      render json: @task, status: :created, location: task_url(@task)
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    head :ok
  end

  private

  def resource_params
    params.permit(:id, :label)
  end
end
