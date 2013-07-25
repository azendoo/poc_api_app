require 'spec_helper'

describe RegistrationsController do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_ACCEPT"] = Mime::JSON
  end

  describe "#create" do

    it "should succeed with valid credentials" do
      post :create, { email: "foo@bar.ok", password: "please" }
      response.should be_success
      JSON.parse(response.body).keys.include?("auth_token")
    end

    it "should fail with invalid credentials" do
      post :create, { email: "", password: ""}
      response.status.should eq(400)
    end

  end

end
