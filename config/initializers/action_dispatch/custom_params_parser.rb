# encoding: utf-8
# XXX :
# We define our own ParamsParser middleware to catch specific exceptions :
# - MultiJson::DecodeError
# - MultiJson::LoadError
# We are only able to catch those exception at this level.
# By doing that we're returning an error when request's body contains
# malformed JSON.
class CustomParamsParser < ActionDispatch::ParamsParser
  def call(env)
    super
  rescue MultiJson::DecodeError, MultiJson::LoadError
    [400, {'Content-Type' => 'application/json'}, ['{"error":"Invalid JSON"}']]
  end
end

# XXX :
# Don't forget to explicitly swap original middleware with our own :
Rails.application.config do
  config.middleware.swap ActionDispatch::ParamsParser, CustomParamsParser
end
