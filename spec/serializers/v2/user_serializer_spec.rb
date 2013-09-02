# encoding: UTF-8
require 'spec_helper'

describe V2::UserSerializer do

  let(:user) { FactoryGirl.create(:user) }
  let(:user_serializer) { V2::UserSerializer.new(user).to_json }

  context "#to_json" do

    it "includes an ID attribute" do
      user_serializer.should have_json_path("id")
    end

    it "includes an email attribute" do
      user_serializer.should have_json_path("email")
    end

    it "includes a task ids attribute" do
      user_serializer.should have_json_path("task_ids")
    end

  end
end
