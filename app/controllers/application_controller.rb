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

  rescue_from Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId do |e|
    render json: {
      errors: 'Not found.'
    }, status: 404
  end

  # needed because store option is set to true in default devise's helper
  def current_user
    @current_user ||= warden.authenticate(scope: :user, store: false)
  end

  private
  def authenticate_user_from_token!
    if current_token = params[:auth_token]
    elsif request.authorization && request.authorization =~ /^Basic (.*)/m
      current_token = Base64.decode64($1).split(/:/, 2)
      current_token = current_token.first
    end

    user = current_token && User.where(authentication_token: current_token).first

    if user
      #warden.authenticate!(scope: :user, store: false)
      sign_in user, store: false
    end
  end

  def default_serializer_options
    {
      serializer_key => serializer
    }
  end

end
