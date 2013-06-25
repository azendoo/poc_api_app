class RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::Helpers
  respond_to :json

  def create
    build_resource
    resource.skip_confirmation!
    if resource.save
      sign_in(resource, store: false)
      render status: 200,
        json: { success: true,
                info: "Registered",
                data: { user: resource,
                        auth_token: current_user.authentication_token } }
    else
      render status: :unprocessable_entity,
        json: { success: false,
                info: resource.errors,
                data: {} }
    end
  end

end
