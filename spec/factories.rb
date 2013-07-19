require "factory_girl"

FactoryGirl.define do
  sequence :email_address do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email { generate(:email_address) }
    password               "please"
    password_confirmation  "please"
  end

  factory :task do
    sequence(:label) { |n| "Task number #{n}" }
    association :user, factory: :user
  end
end
