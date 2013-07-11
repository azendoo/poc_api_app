class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  before_filter :ensure_json_request, :ensure_tokens_presence
  before_filter :authenticate_user!, :check_token_timeout
  after_filter :update_last_activity

  private
  def ensure_json_request
    response.headers['Cache-Control'] = 'no-cache'
    render json: '', status: 406 unless [Mime::ALL,Mime::JSON].include? request.format
  end

  def ensure_tokens_presence
    unless params[:auth_token].blank? or request.headers['Authorization'].blank?
      render json: { errors: "A token is required in order to process that request." }, status: 401
    else
      return
    end
  end

  # XXX WIP
  def check_token_timeout
    return if current_user.nil? or not timedout?
    current_user.reset_authentication_token!
    return if params[:controller].eql?("tokens")
    render json: { errors: 'Timed out. Please sign-in to obtain a new token.' }
  end

  def update_last_activity
    current_user.update_attribute(:last_activity_at, Time.now)
  end

  def timedout?
    !current_user.timeout_in.nil? && current_user.last_activity_at && current_user.last_activity_at <= current_user.timeout_in.ago
  end

  # needed because store option is set to true in default devise's helper
  def current_user
    @current_user ||= warden.authenticate(:scope => :user, :store => false)
  end

end
