class RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::Helpers

  def create
    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      render status: 200,
        json: { auth_token: current_user.authentication_token }
    else
      clean_up_passwords resource
      render status: :unprocessable_entity,
        json: { info: resource.errors }
    end

  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource, store: false)
  end

end
