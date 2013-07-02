class RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::Helpers

  def create

    build_resource(sign_up_params)
    resource.skip_confirmation!

    if resource.save
      sign_up(resource_name, resource)
      render status: 200,
        json: { success: true,
                info: "Registered",
                data: { user: resource,
                        auth_token: current_user.authentication_token } }
    else
      clean_up_passwords resource
      render status: :unprocessable_entity,
        json: { success: false,
                info: resource.errors,
                data: {} }
    end

  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource, store: false)
  end

end
