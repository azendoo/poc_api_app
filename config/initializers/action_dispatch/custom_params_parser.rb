# encoding: utf-8
class CustomParamsParser < ActionDispatch::ParamsParser
  def call(env)
    super
  rescue MultiJson::DecodeError, MultiJson::LoadError
    [400, {'Content-Type' => 'application/json'}, ['{"error":"Invalid JSON"}']]
  end
end

Rails.application.config do
  config.middleware.swap ActionDispatch::ParamsParser, CustomParamsParser
end
