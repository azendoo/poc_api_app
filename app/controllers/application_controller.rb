# encoding: UTF-8
class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_filter :ensure_json_request, :ensure_tokens_presence
  before_filter :authenticate_user!, :check_token_timeout
  after_filter :update_last_activity

  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId do |exception|
    render json: { errors: 'Not found.' }, status: 404
  end

  rescue_from Oj::ParseError do |exception|
    render json: { errors: 'Invalid JSON request.' }, status: :bad_request
  end

  # needed because store option is set to true in default devise's helper
  def current_user
    @current_user ||= warden.authenticate(scope: :user, store: false)
  end

  private

  def ensure_json_request
    response.headers['Cache-Control'] = 'no-cache'
    render json: '', status: 406 unless [Mime::ALL, Mime::JSON].include? request.format

    if request.format == Mime::JSON
      return if Oj.load(request.body.read)
    else
      return
    end
  end

  def ensure_tokens_presence
    if token_params
      render json: { errors: 'A token is required in order to process that request.' }, status: 401
    else
      return
    end
  end

  def token_params
    params[:auth_token].blank? && request.headers['Authorization'].blank?
  end

  # XXX WIP
  def check_token_timeout
    return if current_user.nil? || !timedout?
    return if params[:controller].eql?('tokens')
    render json: { errors: 'Timed out. Please sign-in to obtain a new token.' }, status: 401
  end

  def update_last_activity
    current_user.update_attribute(:last_activity_at, Time.now) unless current_user.nil?
  end

  def timedout?
    return if current_user.nil?
    !current_user.timeout_in.nil? && current_user.last_activity_at && current_user.last_activity_at <= current_user.timeout_in.ago
  end

end
