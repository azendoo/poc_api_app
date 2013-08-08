# encoding: UTF-8
require 'spec_helper'

describe 'Tasks' do

  let(:user) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task, user: user) }

  def new_task
    { label: 'A new task' }.to_json
  end

  let(:json_response) { response.body }

  describe 'GET /tasks' do

    context 'with valid credentials' do
      it 'should succeed' do
        get api_tasks_path, nil, valid_authorization_header
        response.should be_success
      end
    end

    context 'with invalid credentials' do
      it 'should fail' do
        get api_tasks_path, nil, invalid_authorization_header
        response.status.should eq(401)
      end
    end
  end

  describe 'GET /tasks/(:id)' do

    context 'with valid credentials' do
      it 'should succeed' do
        get api_task_path(task.id), nil, valid_authorization_header
        response.should be_success
        json_response.should be_json_eql(
          {
            id: task.id,
            label: task.label,
            user_id: user.id
          }.to_json).excluding('url')
      end
    end

    context 'with invalid credentials' do
      it 'should fail' do
        get api_task_path(task.id), nil, invalid_authorization_header
        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end

    end
  end

  describe 'POST /tasks' do

    context 'with valid credentials' do
      it 'should succeed' do
        post api_tasks_path, valid_task, valid_authorization_header
        response.should be_success
        json_response.should be_json_eql(
          {
            label: task.label,
            user_id: user.id
          }.to_json).excluding('url')
      end
    end

    context 'with invalid credentials' do
      it 'should fail' do
        post api_tasks_path, valid_task, invalid_authorization_header
        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end

  end

  describe 'PUT /tasks/(:id)' do

    context 'with valid credentials' do
      it 'should succeed' do
        put api_task_path(task.id), new_task, valid_authorization_header
        response.should be_success
        json_response.should be_json_eql(
          {
            id: task.id,
            label: 'A new task',
            user_id: user.id
          }.to_json).excluding('url')
      end
    end

    context 'with invalid credentials' do
      it 'should fail' do
        put api_task_path(task.id), new_task, invalid_authorization_header
        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end

  end

  describe 'DELETE /tasks/(:id)' do

    context 'with valid credentials' do
      it 'should succeed' do
        delete api_tasks_path(task.id), nil, valid_authorization_header
        response.should be_success
        Task.count.should eq(0)
      end
    end

    context 'with invalid credentials' do
      it 'should fail' do
        delete api_task_path(task.id), nil, invalid_authorization_header
        response.status.should eq(401)
        json_response.should have_json_path('errors')
        Task.count.should eq(1)
      end
    end

  end

end
