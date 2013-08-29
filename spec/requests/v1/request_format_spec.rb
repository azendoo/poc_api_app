# encoding: UTF-8
require 'spec_helper'

describe 'Request' do

  let(:user) { FactoryGirl.create(:user) }

  describe '#ensure_json_request' do
    it 'should return a 406 if request format isn\'t JSON' do
      post root_path, nil, wrong_http_accept_header
      response.status.should eq(406)
    end

    it 'should return a 200 if request format is JSON' do
      post root_path, nil, valid_authorization_header
      response.status.should eq(200)
    end
  end

end
