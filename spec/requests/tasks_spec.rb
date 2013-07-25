require 'spec_helper'

describe "Tasks" do

  authorization_header = {'HTTP_ACCEPT' => Mime::JSON, "devise.mapping" => Devise.mappings[:user] }

  let(:user) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task, :user => user) }
  let(:json_response) { response.body }

  let(:valid_authorization_header) {
    authorization_token =  ActionController::HttpAuthentication::Basic.encode_credentials(user.authentication_token, nil)
    authorization_header['HTTP_AUTHORIZATION'] = authorization_token
    authorization_header
  }
  let(:invalid_authorization_header) {
    authorization_token =  ActionController::HttpAuthentication::Basic.encode_credentials("123456", nil)
    authorization_header['HTTP_AUTHORIZATION'] = authorization_token
    authorization_header
  }

  describe "GET /tasks" do
    context "with valid credentials" do

      it "should succeed" do

        get '/tasks', nil, valid_authorization_header

        response.should be_success
      end
    end

    context "with invalid credentials" do

      it "should fail" do

        get '/tasks', nil, invalid_authorization_header

        response.status.should eq(401)
      end
    end
  end

  describe "GET /tasks/(:id)" do
    context "with valid credentials" do

      it "should succeed" do

        get "/tasks/#{task.id}", nil, valid_authorization_header

        response.should be_success
        json_response.should be_json_eql({ :id => task.id, :label => task.label, :user_id => user.id }.to_json).excluding("url")
      end
    end

    context "with invalid credentials" do

      it "should fail" do

        get "/tasks/#{task.id}", nil, invalid_authorization_header

        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end
  end

  describe "POST /tasks" do
    context "with valid credentials" do

      it "should succeed" do

        post '/tasks', { task: { label: "Awesome task" } }, valid_authorization_header

        response.should be_success
        json_response.should be_json_eql({ :label => "Awesome task", :user_id => user.id }.to_json).excluding("url")

      end
    end

    context "with invalid credentials" do

      it "should fail" do

        post '/tasks', { :task => task }, invalid_authorization_header

        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end
  end

  describe "PUT /tasks/(:id)" do
    context "with valid credentials" do

      it "should succeed" do

        put "/tasks/#{task.id}",  { task: { label: "Boring task" }}, valid_authorization_header

        response.should be_success
        json_response.should be_json_eql({ :id => task.id, :label => "Boring task", :user_id => user.id }.to_json).excluding("url")
      end
    end

    context "with invalid credentials" do

      it "should fail" do

        put "/tasks/#{task.id}", nil, invalid_authorization_header

        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end
  end

  describe "DELETE /tasks/(:id)" do
    context "with valid credentials" do

      it "should succeed" do

        delete "/tasks/#{task.id}", nil, valid_authorization_header

        response.should be_success
        Task.count.should eq(0)
      end
    end

    context "with invalid credentials" do

      it "should fail" do

        delete "/tasks/#{task.id}", nil, invalid_authorization_header

        response.status.should eq(401)
        json_response.should have_json_path('errors')
        Task.count.should eq(1)
      end
    end
  end
end
