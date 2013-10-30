# encoding: UTF-8
require 'spec_helper'

# XXX :
# Request spec related to application_controller.
# Note: related to old PoC version which used Devise auth token.
describe 'Application' do

  let!(:user) { FactoryGirl.create(:user) }

  context 'on each request with a token' do
    it 'should update user last activity' do
      expect do
        get tasks_path, {}, valid_authorization_header
        user.reload
      end.to change { user.last_activity_at }.from(NilClass).to(Time)
    end
  end

end

