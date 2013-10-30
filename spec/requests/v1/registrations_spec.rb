# encoding: UTF-8
require 'spec_helper'

# XXX :
# Request spec related to registration controller.
# Note: related to old PoC version which used Devise auth token.
describe 'V1::Registrations' do

  let(:user) { FactoryGirl.build(:user) }

  describe '#create' do
    it 'should succeed with valid credentials' do
      post users_path, valid_credentials, base_http_headers
      response.should be_success
      JSON.parse(response.body).keys.include?('auth_token')
    end

    it 'should fail with invalid credentials' do
      post users_path, invalid_credentials, base_http_headers
      response.status.should eq(401)
    end
  end

end
