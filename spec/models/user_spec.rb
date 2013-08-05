# encoding: UTF-8
require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      email: 'foobar@domain.com',
      password: 'please',
      password_confirmation: 'please'
    }
  end

  it 'should create a new instance given valid attributes' do
    User.create!(@attr)
  end

  it 'should require an email address' do
    no_email_user = User.new(@attr.merge(email: ''))
    no_email_user.should_not be_valid
  end

  it 'should reject duplicate email address' do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it 'should create an authentication token' do
    user = User.create!(@attr)
    user.has_attribute? :authentication_token
  end

end
