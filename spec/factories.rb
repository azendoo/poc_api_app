# encoding: UTF-8
require 'factory_girl'

FactoryGirl.define do

  factory :user do
    email { Faker::Internet.email }
    password 'please'
  end

  factory :task do
    sequence(:label) { |n| 'Task number #{n}' }
    association :user, factory: :user
  end
end
