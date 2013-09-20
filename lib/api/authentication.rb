# encoding: utf-8
module Api
  # Handle authentication for HTTP header and params
  module Authentication
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

    def fetch_token(request)
      if authorization_present?
        current_token = fetch_token_from_header(request)
      else
        current_token = params[:auth_token].presence
      end
    end

    def authenticate_from_credentials!(email, password)
      current_user = User.where(email: params[:email]).first

      if current_user.valid_password?(params[:password])
        sign_in current_user, store: false
        current_user.reset_authentication_token! if timedout?
      end
    end
  end
end
