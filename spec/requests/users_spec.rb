require 'spec_helper'

describe "Users" do

  authorization_header = {'HTTP_ACCEPT' => Mime::JSON, "devise.mapping" => Devise.mappings[:user] }

  let(:user) { FactoryGirl.create(:user) }
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

  describe "GET /users" do
    context "with valid credentials" do

      it "should succeed" do

        get '/users', nil, valid_authorization_header

        response.should be_success
      end
    end

    context "with invalid credentials" do

      it "should fail" do

        get '/users', nil, invalid_authorization_header

        response.status.should eq(401)
      end
    end
  end

  describe "GET /users/(:id)" do
    context "with valid credentials" do

      it "should succeed" do

        get "/users/#{user.id}", nil, valid_authorization_header

        response.should be_success
        json_response.should be_json_eql({ :id => user.id, :email => user.email, :task_ids => user.tasks }.to_json).excluding("url")
      end
    end

    context "with invalid credentials" do

      it "should fail" do

        get "/users/#{user.id}", nil, invalid_authorization_header

        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end
  end

  describe "PUT /users/(:id)" do
    context "with valid credentials" do

      it "should succeed" do

        put "/users/#{user.id}",  { user: { email: "stevenseagal@kungfoo.com" }}, valid_authorization_header

        response.should be_success
        json_response.should be_json_eql({ :id => user.id, :email => "stevenseagal@kungfoo.com", :task_ids => user.tasks }.to_json).excluding("url")
      end
    end

    context "with invalid credentials" do

      it "should fail" do

        put "/users/#{user.id}", nil, invalid_authorization_header

        response.status.should eq(401)
        json_response.should have_json_path('errors')
      end
    end
  end

end
