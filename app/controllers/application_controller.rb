# encoding: UTF-8
class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ApiHelpers
  include AmsHelpers

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

    user = current_token && User.where(authentication_token: current_token).first

    # use secure_compare method to mitigate timing attacks
    if user && Devise.secure_compare(user.authentication_token, current_token)
      sign_in user, store: false
    end
  end
end
