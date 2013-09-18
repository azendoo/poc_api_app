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
    if authorization_present?
      current_token = decode_credentials(request).split(':',2).first
    else
      current_token = params[:auth_token]
    end

    user = current_token && User.where(authentication_token: current_token).first

    sign_in(user, store: false) if user
  end

  def authorization_present?
    request.authorization.present? && request.authorization =~ /^Basic (.*)/m
  end

  def default_serializer_options
    {
      serializer_key => serializer
    }
  end

  def decode_credentials(request)
    ::Base64.decode64(request.authorization.split(' ', 2).last || '')
  end
end
