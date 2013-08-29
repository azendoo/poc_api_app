# encoding: UTF-8
class V1::TasksController < ApplicationController
  respond_to :json

  include ActionController::MimeResponds

  resource_description do
    short 'Tasks related endpoints'
    formats ['json']

    error 422, 'Unprocessable entity'
    error 401, 'Unauthorized'
    error 404, 'Resource not found'
  end

  # GET /tasks
  # GET /tasks.json
  api :GET, '/tasks', 'List tasks'
  description 'This endpoint returns all tasks.'
  example Docs::TasksDoc.get_tasks
  def index
    @tasks = Task.all

    render json: @tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  api :GET, '/tasks/:id', 'Show a task'
  param :id, :undef, desc: 'Task id (tasks/:id)', required: true
  description 'This endpoint returns a specific task which looks like this :'
  example Docs::TasksDoc.get_task
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
  api :POST, '/tasks', 'Create a task'
  param_group :task, Docs::TasksDoc
  description 'This endpoint let you crate a new task.'
  example Docs::TasksDoc.new_task
  def create

    @task = Task.new(params)
    @task.user_id = current_user.id

    if @task.save
      render json: @task, status: :created, location: task_url(@task)
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  api :PUT, '/tasks/:id', 'Update a task'
  param :id, :undef, desc: 'Task id (tasks/:id)', required: true
  param_group :task, Docs::TasksDoc
  example Docs::TasksDoc.update_task
  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(params)
      render json: @task, status: :created, location: task_url(@task)
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  api :DELETE, '/tasks/:id', 'Destroy a task'
  param :id, :undef, desc: 'Task id (tasks/:id)', required: true
  example Docs::TasksDoc.delete_task
  def destroy
    binding.pry
    @task = Task.find(params[:id])
    @task.destroy

    head :no_content, status: :ok
  end

end
