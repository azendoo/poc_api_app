# encoding: UTF-8
require 'spec_helper'

describe V2::TaskSerializer do

  let(:task) { FactoryGirl.create(:task) }
  let(:task_serializer) { V2::TaskSerializer.new(task).to_json }

  context '#to_json' do

    it 'includes an ID attribute' do
      task_serializer.should have_json_path('id')
    end

    it 'includes a label attribute' do
      task_serializer.should have_json_path('label')
    end

    it 'includes an user id attribute' do
      task_serializer.should have_json_path('user_id')
    end

  end
end
