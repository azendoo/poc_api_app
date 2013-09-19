# encoding: UTF-8
module ApiHelpers
  ## request validation related helpers ##
  def valid_mime_type?
    accepted_types = [Mime::ALL, Mime::JSON, Mime::API_V1, Mime::API_V2]
    accepted_types.include? request.content_type
  end

  def ensure_valid_format
    head :bad_request unless valid_mime_type?
  end

  def token_present?
    params[:auth_token].present? || request.headers['Authorization'].present?
  end

  def ensure_token_presence
    if !token_present?
      render json: {
        errors: 'A token is required in order to process that request.'
      }, status: 401
    else
      return
    end
  end

  def ensure_credentials_presence
    if credentials_present?
      return
    else
      render json: {
        errors: 'Missing email or password attribute' },
        status: :unauthorized
    end
  end

  ## timeout related helpers ##
  def update_last_activity
    current_user.update_attribute(:last_activity_at, Time.now)
  end

  def check_token_timeout
    return unless timedout?
    render json: {
      errors: 'Timed out. Please sign-in to obtain a new token.'
    }, status: 401
  end

  def timedout?
    last_access = current_user.last_activity_at
    expiration_time = current_user.timeout_in.ago

    current_user.timeout_in && last_access && last_access <= expiration_time
  end

  ## authentication related helpers ##
  def credentials_present?
    params[:email].present? && params[:password].present?
  end

  def authorization_present?
    request.authorization.present? && request.authorization =~ /^Basic (.*)/m
  end

  def decode_credentials(request)
    ::Base64.decode64(request.authorization.split(' ', 2).last || '')
  end

  def fetch_token_from_header(request)
    decode_credentials(request).split(':', 2).first
  end

  def fetch_token(request)
    if authorization_present?
      current_token = fetch_token_from_header(request)
    else
      current_token = params[:auth_token].presence
    end
  end

  def authenticate_from_credentials!(email, password)
    current_user = User.where(email: params[:email]).first

    if current_user.valid_password?(params[:password])
      sign_in current_user, store: false
      current_user.reset_authentication_token! if timedout?
    end
  end
end
