# encoding: UTF-8
# XXX :
# Override Devise's failure app behavior to
# render json responses instead of pure HTML.
class CustomFailure < Devise::FailureApp
  def respond
    http_auth
  end

  def redirect
    if flash[:timedout] && flash[:alert]
      flash.keep(:timedout)
      flash.keep(:alert)
    else
      flash[:alert] = i18n_message
    end
  end

  def http_auth
    self.status = 401
    self.content_type = Mime::JSON
    self.response_body = http_auth_body
  end

  def http_auth_body
    return i18n_message unless request_format
    { :errors => i18n_message }.to_json.encode("UTF-8")
  end
end
