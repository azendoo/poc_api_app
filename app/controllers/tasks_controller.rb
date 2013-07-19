class TasksController < ApplicationController
  include ActionController::MimeResponds

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

    render json: @tasks.to_a, :each_serializer => TaskSerializer
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
    @task = current_user.tasks.build(params[:task])
    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(params[:task])
      response.headers['Cache-Control'] = 'no-cache'
      render json: ''
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    head :no_content
  end

end
