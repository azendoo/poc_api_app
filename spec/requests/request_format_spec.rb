# encoding: UTF-8
require 'spec_helper'

describe 'Request' do

  let(:user) { FactoryGirl.create(:user) }

  describe '#ensure_json_request' do
    it 'should return a 406 if request format isn\'t JSON' do
      post api_root_path, format: Mime::HTML
      response.status.should eq(406)
    end

    it 'should return a 200 if request format is JSON' do
      post api_root_path, nil, valid_authorization_header
      response.status.should eq(200)
    end
  end

end
