# encoding: UTF-8
# XXX :
# In order to easily test our json outputs within
# RSpec, we should include json_spec helpers.
RSpec.configure do |config|
    config.include JsonSpec::Helpers
end
