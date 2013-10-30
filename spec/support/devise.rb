# encoding: UTF-8
# XXX : required to have access to Devise and Warden helpers
# within our request specs.
RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  Warden.test_mode!
  config.include Warden::Test::Helpers, type: :request
  config.after(:each, type: :request) { Warden.test_reset! }
end

