require 'spec_helper'

describe RegistrationsController do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_ACCEPT"] = Mime::JSON
  end

  describe "POST create" do

    it "should succeed with valid credentials" do
      post :create, :user => { email: "foo@bar.ok", password: "please", password_confirmation: "please" }
      response.should be_success
      JSON.parse(response.body).keys.include?("auth_token")
    end

    it "should fail with invalid credentials" do
      post :create, :user => {}
      response.status.should eq(422)
    end

  end

end
