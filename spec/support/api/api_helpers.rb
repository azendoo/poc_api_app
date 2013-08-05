# encoding: UTF-8
module APIHelpers

  def base_http_headers
  {
    'HTTP_ACCEPT'    => 'application/json',
    'CONTENT_TYPE'   => 'application/json',
    'devise.mapping' => Devise.mappings[:user]
  }
  end

  def valid_authorization_header
    authorization_header = base_http_headers
    authorization_token =  ActionController::HttpAuthentication::Basic.encode_credentials(user.authentication_token, nil)
    authorization_header['HTTP_AUTHORIZATION'] = authorization_token
    authorization_header
  end

  def invalid_authorization_header
    authorization_header = base_http_headers
    authorization_token =  ActionController::HttpAuthentication::Basic.encode_credentials('123456', nil)
    authorization_header['HTTP_AUTHORIZATION'] = authorization_token
    authorization_header
  end

  # Authentication credentials
  def valid_credentials
    { email: user.email, password: user.password }.to_json
  end

  def invalid_credentials
    { email: 'foobardomaincom', password: '' }.to_json
  end

  # Authentication token :
  def valid_token
    { auth_token: user.authentication_token }.to_json
  end

  def invalid_token
    { auth_token: 'FOOBAR' }.to_json
  end

  # Tasks :

  ## valid task :
  def valid_task
    { label: task.label }.to_json
  end

end
