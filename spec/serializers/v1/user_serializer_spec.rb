# encoding: UTF-8
require 'spec_helper'

# XXX : use json_spec to validate our serializers.
describe V1::UserSerializer do

  let(:user) { FactoryGirl.create(:user) }
  let(:user_serializer) { V1::UserSerializer.new(user).to_json }

  context '#to_json' do

    it 'includes an ID attribute' do
      user_serializer.should have_json_path('id')
    end

    it 'includes an email attribute' do
      user_serializer.should have_json_path('email')
    end

    it 'includes an url attribute' do
      user_serializer.should have_json_path('url')
    end

    it 'includes a task ids attribute' do
      user_serializer.should have_json_path('task_ids')
    end

  end
end
