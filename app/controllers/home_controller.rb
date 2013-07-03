class HomeController < ApplicationController

  def index
    links = {
      users_url: users_url + "/{id}",
      tasks_url: tasks_url + "/{id}",
      tokens: tokens_url + "/{id}"
    }
    render json: links.to_json
  end

end
