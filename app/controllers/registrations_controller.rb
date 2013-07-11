class RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::Helpers
  skip_before_filter :authenticate_user!, :check_token_timeout, :ensure_tokens_presence
  skip_after_filter :update_last_activity

  def create
    user = User.new(params[:user])
    if user.save
      render status: 201, json: { email: user.email, auth_token: user.authentication_token }
      return
    else
      clean_up_passwords user
      render status: :unprocessable_entity, json: { errors: user.errors }
    end
  end

end
