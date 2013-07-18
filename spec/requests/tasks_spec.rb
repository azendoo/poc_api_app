require 'spec_helper'

describe "Tasks" do

  env_headers = {'HTTP_ACCEPT' => Mime::JSON, "devise.mapping" => Devise.mappings[:user] }

  describe "GET /tasks" do
    context "with valid credentials" do
      user = FactoryGirl.build(:user)
      authorization_header =  ActionController::HttpAuthentication::Basic.encode_credentials(user.authentication_token, nil)
      env_headers['HTTP_AUTHORIZATION'] = authorization_header

      it "should succeed" do
        get '/tasks', nil, env_headers
      end
    end

    context "with invalid credentials" do
      authorization_header = ActionController::HttpAuthentication::Basic.encode_credentials("123456", nil)
      env_headers['HTTP_AUTHORIZATION'] = authorization_header

      it "should fail" do
        get '/tasks', nil, env_headers
        response.status.should eq(401)
      end
    end

  end
end
