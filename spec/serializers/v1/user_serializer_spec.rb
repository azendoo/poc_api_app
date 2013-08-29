# encoding: UTF-8
require 'spec_helper'

describe V1::UserSerializer do
  let(:attributes) { FactoryGirl.attributes_for(resource_name) }

  it { should have_attribute(:id) }
  it { should have_attribute(:email) }
  it { should have_attribute(:url) }

  it { should embed(:ids) }

end
