# encoding: utf-8
module Api
  # XXX :  Related users (token) timeout management.
  module Timeout
    # XXX : Force user's last activity on each API request:
    def update_last_activity
      current_user.update_attribute(:last_activity_at, Time.now)
    end

    # XXX :
    # Old filter used in the first PoC based on Devise's authentication
    # token. Its goal was to work with the update_last_activity method
    # and check on each request if the given token was expired or not.
    # Since we're going to use Bearer access tokens of OAuth2 we should
    # simply rely on refresh mechanism.
    def check_token_timeout
      return unless timedout?
      render json: {
        errors: 'Timed out. Please sign-in to obtain a new token.'
      }, status: 401
    end

    def timedout?
      last_access = current_user.last_activity_at
      expiration_time = current_user.timeout_in.ago

      current_user.timeout_in && last_access && last_access <= expiration_time
    end
  end
end
