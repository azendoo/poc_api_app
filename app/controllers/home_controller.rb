class HomeController < ApplicationController
  skip_before_filter :ensure_tokens_presence
  skip_before_filter :authenticate_user!, :check_token_timeout
  skip_after_filter :update_last_activity
  # XXX : temporary
  def index
    links = {
      login_url:  url_for(controller:'tokens', action: 'create'),
      logout_url: url_for(controller:'tokens', action: 'destroy'),
      users_url:  users_url   + "/{id}",
      tasks_url:  tasks_url   + "/{id}"
    }
    render json: links.to_json
  end

end
