require 'spec_helper'

describe RegistrationsController do

  let(:user){ FactoryGirl.build(:user)}

  # Authentication attributes :
  def valid_attributes
    {:email => user.email, :password => user.password}
  end

  def invalid_attributes
    {:email => 'foobardomaincom', :password => ''}
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_ACCEPT"] = Mime::JSON
    @request.env["CONTENT_TYPE"] = Mime::JSON
  end

  describe "#create" do
    it "should succeed with valid credentials" do
      # Required to send raw JSON data :
      request.env['RAW_POST_DATA'] = valid_attributes.to_json

      # Create a new account :
      post :create, valid_attributes

      # Checks :
      response.should be_success
      JSON.parse(response.body).keys.include?("auth_token")
    end

    it "should fail with invalid credentials" do
      # Required to send raw JSON data :
      request.env['RAW_POST_DATA'] = invalid_attributes.to_json

      # Create a new account :
      post :create, invalid_attributes

      # Checks :
      response.status.should eq(400)
    end

  end

end
