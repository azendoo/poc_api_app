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
    unless token_present?
      render json: {
        errors: 'A token is required in order to process that request.'
      }, status: 401
    else
      return
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
    !current_user.timeout_in.nil? && current_user.last_activity_at && current_user.last_activity_at <= current_user.timeout_in.ago
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
    decode_credentials(request).split(':',2).first
  end

  def fetch_token(request)
    if authorization_present?
      current_token = fetch_token_from_header(request)
    else
      current_token = params[:auth_token].presence
    end
  end
end
