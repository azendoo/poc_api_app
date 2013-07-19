require 'spec_helper'

describe "Tasks" do

  env_headers = {'HTTP_ACCEPT' => Mime::JSON, "devise.mapping" => Devise.mappings[:user] }

  let(:user) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task, :user => user) }
  let(:json_response) { response.body }

  describe "GET /tasks" do
    context "with valid credentials" do

      it "should succeed" do
        authorization_header =  ActionController::HttpAuthentication::Basic.encode_credentials(user.authentication_token, nil)
        env_headers['HTTP_AUTHORIZATION'] = authorization_header

        get '/tasks', nil, env_headers

        json_response.should have_json_path("tasks")
        response.should be_success
      end
    end

    context "with invalid credentials" do

      it "should fail" do
        authorization_header = ActionController::HttpAuthentication::Basic.encode_credentials("123456", nil)
        env_headers['HTTP_AUTHORIZATION'] = authorization_header

        get '/tasks', nil, env_headers

        response.status.should eq(401)
      end
    end
  end

  describe "POST /tasks" do
    context "with valid credentials" do

      it "should succeed" do
        authorization_header =  ActionController::HttpAuthentication::Basic.encode_credentials(user.authentication_token, nil)
        env_headers['HTTP_AUTHORIZATION'] = authorization_header

        post '/tasks', { task: { label: "Awesome task" } }, env_headers

        response.should be_success
        json_response.should have_json_path('task')
        json_response.should be_json_eql({ :label => "Awesome task", :user_id => user.id }.to_json).excluding("url").at_path("task")

      end
    end

    context "with invalid credentials" do

      it "should fail" do
        authorization_header = ActionController::HttpAuthentication::Basic.encode_credentials("123456", nil)
        env_headers['HTTP_AUTHORIZATION'] = authorization_header

        post '/tasks', { :task => task }, env_headers

        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end
  end


end
