# encoding: utf-8
module Api
  # XXX : Related to request format validation
  module Request

    # XXX :
    # Whitelist of valid and supported media types.
    # For testing purpose we also have two MIME types,
    # one for each API version :
    def valid_mime_type?
      accepted_types = [Mime::ALL, Mime::JSON, Mime::API_V1, Mime::API_V2]
      accepted_types.include? request.accept
    end

    def ensure_valid_format
      unless valid_mime_type?
        render json: {
          errors: 'Invalid media type.'
        }, status: :bad_request
      end
    end

    def token_present?
      params[:auth_token].present? || request.headers['Authorization'].present?
    end

    def ensure_token_presence
      if !token_present?
        render json: {
          errors: 'A token is required in order to process that request.'
        }, status: :unauthorized
      else
        return
      end
    end

    # XXX :
    # Should be removed if authentication is only done through
    # Doorkeeper's grant_type password flow :
    def ensure_credentials_presence
      if credentials_present?
        return
      else
        render json: {
          errors: 'Missing email or password attribute'
        }, status: :unauthorized
      end
    end
  end
end

