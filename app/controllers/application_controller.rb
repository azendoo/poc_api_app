# encoding: UTF-8
class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Api::Authentication
  include Api::Serializer
  include Api::Request
  include Api::Timeout

  before_filter :ensure_valid_format
  before_filter :ensure_token_presence
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  before_filter :check_token_timeout
  after_filter :update_last_activity

  rescue_from Mongoid::Errors::DocumentNotFound,
              BSON::InvalidObjectId do |e|
    render json: {
      errors: 'Not found.'
    }, status: 404
  end

  def current_user
    @current_user ||= warden.authenticate(scope: :user, store: false)
  end

  private

  def authenticate_user_from_token!
    # get auth token from HTTP header
    # (Authorization) or params[:auth_token]
    current_token = fetch_token(request)
    current_user  = User.where(authentication_token: current_token).first

    return unless current_user

    match_user = current_token && current_user
    # use secure_compare method to mitigate timing attacks
    match_token = safe_compare current_user.authentication_token, current_token

    sign_in(current_user, store: false) if match_user && match_token
  end

  def safe_compare(a, b)
    Devise.secure_compare a, b
  end
end
