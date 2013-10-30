# encoding: UTF-8
require 'spec_helper'

# XXX :
# It uses 'json-spec' to validate responses.
# Note: related to old PoC version which used Devise auth token.
# It was to check for a different behavior between API_V1 and API_V2.
describe 'V2::Users' do

  let(:user) { FactoryGirl.create(:user) }
  let(:json_response) { response.body }
  let(:new_user) do
    { email: 'stevenseagal@kungfoo.com' }.to_json
  end

  describe 'GET /users' do

    context 'with valid credentials' do
      it 'should succeed' do
        get users_path, nil, valid_authorization_header_v2
        response.should be_success
      end
    end

    context 'with invalid credentials' do
      it 'should fail' do
        get users_path, nil, invalid_authorization_header
        response.status.should eq(401)
      end
    end

  end

end
