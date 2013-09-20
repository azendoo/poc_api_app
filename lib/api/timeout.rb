# encoding: utf-8
module Api
  # Related users (token) timeout management
  module Timeout

  def update_last_activity
    current_user.update_attribute(:last_activity_at, Time.now)
  end

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
