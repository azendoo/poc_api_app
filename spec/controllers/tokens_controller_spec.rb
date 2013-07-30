require 'spec_helper'

describe TokensController do

  let(:user){ FactoryGirl.create(:user)}

  # Authentication attributes :
  def valid_attributes
    {:email => user.email, :password => user.password}
  end

  def invalid_attributes
    {:email => 'foobardomaincom', :password => ''}
  end

  # Authentication token :
  def valid_token
    {:auth_token => user.authentication_token}
  end

  def invalid_token
    {:auth_token => "FOOBAR"}
  end

  # Settings for request :
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_ACCEPT"] = Mime::JSON
    @request.env["CONTENT_TYPE"] = Mime::JSON
  end

  describe "#create" do

    it "should succeed with valid credentials" do
      # Required to send raw JSON data :
      request.env['RAW_POST_DATA'] = valid_attributes.to_json

      # Create a token :
      post :create, valid_attributes

      # Checks :
      response.should be_success
      JSON.parse(response.body).keys.include?("auth_token")
    end

    it "should fail with invalid credentials" do
      # Required to send raw JSON data :
      request.env['RAW_POST_DATA'] = invalid_attributes.to_json

      # Create a token :
      post :create, invalid_attributes

      # Checks :
      response.status.should eq(401)
      JSON.parse(response.body).keys.should_not include("auth_token")
    end
  end

  describe "#destroy" do
    it "should succeed with valid credentials" do
      # Required to send raw JSON data :
      request.env['RAW_POST_DATA'] = valid_token.to_json

      # Destroy a token :
      delete :destroy, valid_token

      # Checks :
      response.should be_success
    end

    it "should fail with invalid credentials" do
      # Required to send raw JSON data :
      request.env['RAW_POST_DATA'] = invalid_token.to_json

      # Destroy a token :
      delete :destroy, invalid_token

      # Checks :
      response.status.should eq(401)
    end
  end

end
