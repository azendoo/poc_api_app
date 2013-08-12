# encoding: UTF-8
class Api::V1::HomeController < ApplicationController
  skip_before_filter :ensure_tokens_presence
  skip_before_filter :authenticate_user!, :check_token_timeout
  skip_after_filter :update_last_activity

  # XXX : temporary
  def index
    links = {
      login_urli: api_login_url,
      logout_url: api_logout_url,
      users_url:  api_users_url   + '/{id}',
      tasks_url:  api_tasks_url   + '/{id}'
    }
    render json: links.to_json
  end

end
