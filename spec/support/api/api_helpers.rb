# encoding: UTF-8
module APIHelpers
  # XXX :
  # Yep, the following file is quite huge.
  # It reflects various helpers which were used in the old PoC
  # version (Devise auth_token). Those helpers are mainly defining
  # various HTTP headers with particular MIME types and Authorization
  # headers.

  def base_http_headers
    {
      'HTTP_ACCEPT'    => 'application/json',
      'CONTENT_TYPE'   => 'application/json',
      'devise.mapping' => Devise.mappings[:user]
    }
  end

  def base_http_headers_v2
    {
      'HTTP_ACCEPT'    => 'application/vnd.azendoo+json; version=2',
      'CONTENT_TYPE'   => 'application/json',
      'devise.mapping' => Devise.mappings[:user]
    }
  end

  def wrong_http_accept_header
    {
      'HTTP_ACCEPT'    => 'application/html',
      'CONTENT_TYPE'   => 'application/html'
    }
  end

  def valid_authorization_header_v2
    authorization_header = base_http_headers_v2
    authorization_token =  encode_credentials(user.authentication_token, nil)
    authorization_header['HTTP_AUTHORIZATION'] = authorization_token
    authorization_header
  end

  def valid_authorization_header
    authorization_header = base_http_headers
    authorization_token =  encode_credentials(user.authentication_token, nil)
    authorization_header['HTTP_AUTHORIZATION'] = authorization_token
    authorization_header
  end

  def invalid_authorization_header
    authorization_header = base_http_headers
    authorization_token =  encode_credentials('123456', nil)
    authorization_header['HTTP_AUTHORIZATION'] = authorization_token
    authorization_header
  end

  def encode_credentials(user_name, password)
    "Basic #{::Base64.strict_encode64("#{user_name}:#{password}")}"
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
