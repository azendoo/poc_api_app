require 'spec_helper'

describe "App" do

  authorization_header = {'HTTP_ACCEPT' => Mime::JSON, "devise.mapping" => Devise.mappings[:user] }

  let!(:user) { FactoryGirl.create(:user) }

  let(:valid_authorization_header) {
    authorization_token =  ActionController::HttpAuthentication::Basic.encode_credentials(user.authentication_token, nil)
    authorization_header['HTTP_AUTHORIZATION'] = authorization_token
    authorization_header
  }

  context "on each request with a token" do

    it "should update user last activity" do
      expect {
        get '/tasks', nil, valid_authorization_header
        user.reload
      }.to change { user.last_activity_at }.from(NilClass).to(Time)
    end

  end

end

