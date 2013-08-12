# encoding: UTF-8
require 'spec_helper'

describe 'Tokens' do

  let(:user) { FactoryGirl.create(:user) }

  describe '#create' do

    it 'should succeed with valid credentials' do
      post api_login_path, valid_credentials, base_http_headers
      response.should be_success
      JSON.parse(response.body).keys.include?('auth_token')
    end

    it 'should fail with invalid credentials' do
      post api_login_path, invalid_credentials, base_http_headers
      response.status.should eq(401)
      JSON.parse(response.body).keys.should_not include('auth_token')
    end

  end

  describe '#destroy' do

    it 'should succeed with valid credentials' do
      delete api_logout_path, valid_token, base_http_headers
      response.should be_success
    end

    it 'should fail with invalid credentials' do
      delete api_logout_path, invalid_token, base_http_headers
      response.status.should eq(401)
    end

  end

end
