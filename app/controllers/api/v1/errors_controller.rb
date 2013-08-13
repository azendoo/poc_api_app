# encoding: UTF-8
class Api::V1::ErrorsController < ApplicationController
  def not_found
    render json: {
      errors: :not_found
    }, status: :not_found
  end

  def unprocessable
    render json: {
      errors: :unprocessable_entity
    }, status: :unprocessable_entity
  end

  def internal_server
    render json: {
      errors: :internal_server_error
    }, status: :internal_server_error
  end
end
