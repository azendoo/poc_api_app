# encoding: UTF-8
class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ApiHelpers

  before_filter :ensure_json_request, :ensure_tokens_presence
  before_filter :authenticate_user!, :check_token_timeout
  after_filter :update_last_activity

  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId do |e|
    render json: {
      errors: 'Not found.'
    }, status: 404
  end

  rescue_from Oj::ParseError do |e|
    render json: {
      errors: 'Invalid JSON request.'
    }, status: :bad_request
  end

  # needed because store option is set to true in default devise's helper
  def current_user
    @current_user ||= warden.authenticate(scope: :user, store: false)
  end

end
