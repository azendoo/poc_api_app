# encoding: UTF-8
class HomeController < ApplicationController
  respond_to :json

  skip_before_filter :ensure_token_presence
  skip_before_filter :authenticate_user!
  skip_before_filter :authenticate_user_from_token
  skip_before_filter :check_token_timeout
  skip_after_filter :update_last_activity

  # XXX : just for fun. 
  # A hypermedia flavor Github's style.
  def index
    root_representation = {
      login_url:  login_url,
      logout_url: logout_url,
      users_url:  users_url   + '/{id}',
      tasks_url:  tasks_url   + '/{id}'
    }.to_json

    render json: root_representation
  end

end
