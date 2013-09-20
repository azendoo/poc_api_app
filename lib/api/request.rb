# encoding: utf-8
module Api
  # Related to request format validation
  module Request
    def valid_mime_type?
      accepted_types = [Mime::ALL, Mime::JSON, Mime::API_V1, Mime::API_V2]
      accepted_types.include? request.content_type
    end

    def ensure_valid_format
      head :bad_request unless valid_mime_type?
    end

    def token_present?
      params[:auth_token].present? || request.headers['Authorization'].present?
    end

    def ensure_token_presence
      if !token_present?
        render json: {
          errors: 'A token is required in order to process that request.'
        }, status: 401
      else
        return
      end
    end

    def ensure_credentials_presence
      if credentials_present?
        return
      else
        render json: {
          errors: 'Missing email or password attribute' },
          status: :unauthorized
      end
    end
  end
end

