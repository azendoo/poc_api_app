require 'spec_helper'

describe TasksController, :type => :controller do

  before(:each) do
    @request.env["HTTP_ACCEPT"] = Mime::JSON
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET index" do

    context "with valid credentials" do
      before do
        user = FactoryGirl.create(:user)
        header =  ActionController::HttpAuthentication::Basic.encode_credentials(user.authentication_token, nil)
        request.env['HTTP_AUTHORIZATION'] = header
      end

      it "should succeed" do
        get :index
        response.should be_success
      end

    end

    context "with invalid credentials" do

      it "should fail" do
        header = ActionController::HttpAuthentication::Basic.encode_credentials("123456", nil)
        get :index
        response.status.should eq(401)
      end

    end

  end
end
