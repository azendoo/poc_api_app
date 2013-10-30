# encoding: utf-8
module Api
  # XXX : Handle authentication for HTTP header and params
  module Authentication
    # XXX : Sould be removed if authentication is done on provider.
    def credentials_present?
      params[:email].present? && params[:password].present?
    end

    def authorization_present?
      request.authorization.present? && request.authorization =~ /^Basic (.*)/m
    end

    def decode_credentials(request)
      ::Base64.decode64(request.authorization.split(' ', 2).last || '')
    end

    def fetch_token_from_header(request)
      decode_credentials(request).split(':', 2).first
    end

    # XXX : Fetch token from Authorization HTTP header, if not
    # present check on given params :
    def fetch_token(request)
      if authorization_present?
        current_token = fetch_token_from_header(request)
      else
        current_token = params[:auth_token].presence
      end
    end

    # XXX :
    # Should be removed if authentication is only done on
    # OAuth2 provider's side using the grant_type OAuth strategy.
    def authenticate_from_credentials!(email, password)
      current_user = User.where(email: params[:email]).first
      return if current_user.nil?

      if current_user.valid_password?(params[:password])
        sign_in current_user, store: false
        current_user.reset_authentication_token! if timedout?
      end
    end
  end
end
