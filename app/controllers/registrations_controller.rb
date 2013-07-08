class RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::Helpers

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
