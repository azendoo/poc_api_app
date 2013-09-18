class CustomParamsParser < ActionDispatch::ParamsParser
  def call(env)
    super
  rescue MultiJson::DecodeError
    [400, {}, []]
  end
end
