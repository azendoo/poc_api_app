# encoding: UTF-8
class V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  include Devise::Controllers::Helpers

  before_filter :ensure_credentials_presence

  skip_before_filter :authenticate_user_from_token!
  skip_before_filter :authenticate_user!
  skip_before_filter :check_token_timeout
  skip_before_filter :ensure_token_presence
  skip_after_filter :update_last_activity

  # POST /users
  # POST /users.json
  def create
    u = User.new(resource_params)


    #XXX WIP
    if u.save
      # ask for a brand new oauth token
      if u.access_tokens.blank?
        response  = RestClient.post("#{APP_CONFIG['doorkeeper_app_url']}/oauth/token", \
                                    grant_type: "password", \
                                    client_id: APP_CONFIG['doorkeeper_app_id'], \
                                    client_secret: APP_CONFIG['doorkeeper_app_secret'], \
                                    username: params['email'], \
                                    password: params['password'])

        token_infos = JSON.parse(response.body)
        render json: token_infos, status: :created
      else
        # lets do something in the future if there's a problem
        # with the oauth provider
      end
    else
      clean_up_passwords u
      render  json: { errors: u.errors }, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.permit(:email, :password)
  end
end
