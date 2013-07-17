require 'spec_helper'

describe TokensController do

  let(:user){ FactoryGirl.create(:user)}

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_ACCEPT"] = Mime::JSON
  end

  describe "#create" do

    it "should succeed with valid credentials" do
      post :create, :user => { email: user.email, password: user.password }
      response.should be_success
      JSON.parse(response.body).keys.include?("auth_token")
    end

    it "should fail with invalid credentials" do
      post :create, :user => { email: "1234567", password: "foobar" }
      response.status.should eq(401)
    end

  end

  describe "#destroy" do

    it "should succeed with valid credentials" do
      post :destroy, :auth_token => user.authentication_token
      response.should be_success
    end

    it "should fail with invalid credentials" do
      post :destroy, :auth_token => user.authentication_token
      response.status.should eq(201)
    end

  end

end
