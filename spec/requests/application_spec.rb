# encoding: UTF-8
require 'spec_helper'

describe 'Application' do

  let!(:user) { FactoryGirl.create(:user) }

  context 'on each request with a token' do
    it 'should update user last activity' do
      expect do
        get api_tasks_path, {}, valid_authorization_header
        user.reload
      end.to change { user.last_activity_at }.from(NilClass).to(Time)
    end
  end

end

