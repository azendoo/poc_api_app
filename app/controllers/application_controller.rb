# encoding: UTF-8
class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Api::Authentication
  include Api::Serializer
  include Api::Request
  include Api::Timeout

  respond_to :json

  # XXX : old filters list used in previous PoC version
  before_filter :ensure_valid_format
  before_filter :ensure_token_presence
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  before_filter :check_token_timeout
  after_filter :update_last_activity

  # XXX : required to render 404 in JSON format
  rescue_from Mongoid::Errors::DocumentNotFound,
    BSON::InvalidObjectId do |e|
    render json: {
      errors: 'Not found.'
    }, status: 404
  end

  rescue_from CanCan::AccessDenied do |exception|
    head :unauthorized
  end

  def current_user
    @current_user ||= warden.authenticate(scope: :user, store: false)
  end

  private

  # XXX : should be updated to mitigate timing attacks ?
  # That's the question :
  # http://blog.plataformatec.com.br/2013/08/devise-3-1-now-with-more-secure-defaults/
  #
  # token_authenticatable was removed by Devise because of possible timing attacks
  # on tokens lookup Devise's system. Generated tokens by Devise were 20 chars long.
  # With Doorkeeper we are dealing with longer tokens of 32 chars. I think it will definitely
  # make timing attacks trickier. More, there's was no real PoC of such attack on the
  # database authentication used by Devise. José Valim directly removed token_authenticatable
  # by fear of eventual problems because of the context (large opensource project) and
  # lack of informations.
  def authenticate_user_from_token!
    # Get auth token from :
    # (Authorization) or params[:auth_token]
    user_token = fetch_token(request)
    user  = user_token && User.find_by_token(user_token)

    sign_in(user, store: false) if user
  end

end
