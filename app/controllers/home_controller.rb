class HomeController < ApplicationController

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
