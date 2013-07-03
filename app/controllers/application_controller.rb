class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  before_filter :ensure_json_request

  private
  def ensure_json_request
    render json: '{}', status: 406 unless [Mime::ALL,Mime::JSON].include? request.format
  end
end
