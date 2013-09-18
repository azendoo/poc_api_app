# encoding: UTF-8
module ApiHelpers
  def valid_mime_type?
    accepted_types = [Mime::ALL, Mime::JSON, Mime::API_V1, Mime::API_V2]
    accepted_types.include? request.content_type
  end

  def token_present?
    params[:auth_token].present? || request.headers['Authorization'].present?
  end

  def ensure_valid_format
    head :bad_request unless valid_mime_type?
  end

  def update_last_activity
    current_user.update_attribute(:last_activity_at, Time.now)
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

  def check_token_timeout
    return unless timedout?
    render json: {
      errors: 'Timed out. Please sign-in to obtain a new token.'
    }, status: 401
  end

  def timedout?
    !current_user.timeout_in.nil? && current_user.last_activity_at && current_user.last_activity_at <= current_user.timeout_in.ago
  end

end
