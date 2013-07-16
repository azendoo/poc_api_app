require "factory_girl"

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password               "please"
  end

  factory :task do
    label                 "a task"
  end
end
