# encoding: UTF-8
require 'spec_helper'

describe 'V1::Users' do

  let(:user) { FactoryGirl.create(:user) }
  let(:json_response) { response.body }
  let(:new_user) do
    { email: 'stevenseagal@kungfoo.com' }.to_json
  end

  describe 'GET /users' do

    context 'with valid credentials' do
      it 'should succeed' do
        get users_path, nil, valid_authorization_header
        response.should be_success
      end
    end

    context 'with invalid credentials' do
      it 'should fail' do
        get users_path, nil, invalid_authorization_header
        response.status.should eq(401)
      end
    end

  end

  describe 'GET /users/(:id)' do

    context 'with valid credentials' do
      it 'should succeed' do
        get user_path(user.id), nil, valid_authorization_header
        response.should be_success
        json_response.should be_json_eql(
          {
            id: user.id,
            email: user.email,
            task_ids: user.tasks
          }.to_json).excluding('url')
      end
    end

    context 'with invalid credentials' do
      it 'should fail' do
        get user_path(user.id), nil, invalid_authorization_header
        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end

  end

  describe 'PUT /users/(:id)' do

    context 'with valid credentials' do
      it 'should succeed' do
        put user_path(user.id), new_user, valid_authorization_header
        response.should be_success
        json_response.should be_json_eql(
          {
            id: user.id,
            email: 'stevenseagal@kungfoo.com',
            task_ids: user.tasks
          }.to_json).excluding('url')
      end
    end

    context 'with invalid credentials' do
      it 'should fail' do
        put user_path(user.id), nil, invalid_authorization_header
        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end

  end
end
