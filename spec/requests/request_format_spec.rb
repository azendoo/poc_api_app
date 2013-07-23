require 'spec_helper'

describe "ApplicationController" do

  let(:user) { FactoryGirl.create(:user) }
  authorization_header = {'HTTP_ACCEPT' => Mime::JSON, "devise.mapping" => Devise.mappings[:user] }

  let(:valid_authorization_header) {
    authorization_token =  ActionController::HttpAuthentication::Basic.encode_credentials(user.authentication_token, nil)
    authorization_header['HTTP_AUTHORIZATION'] = authorization_token
    authorization_header
  }

  describe "#ensure_json_request" do
    it "should return a 406 if request format isn't JSON" do
      post "/", :format => Mime::HTML
      response.status.should eq(406)
    end

    it "should return a 200 if request format is JSON" do
      post "/", nil, valid_authorization_header
      response.status.should eq(200)
    end
  end

end
