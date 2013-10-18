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

  # TODO : should be updated to mitigate timing attacks
  def authenticate_user_from_token!
    # get auth token from HTTP header
    # (Authorization) or params[:auth_token]
    user_token = fetch_token(request)
    user  = user_token && User.find_by_token(user_token)

    sign_in(user, store: false) if user
  end

end
