class ActionDispatch::ShowExceptions
  def call(env)
    status, headers, body = @app.call(env)

    if headers['X-Cascade'] == 'pass'
      raise ActionController::RoutingError, "No route matches #{env['PATH_INFO'].inspect}"
    end

    [status, headers, body]
  rescue Exception => exception
    raise exception if env['action_dispatch.show_exceptions'] == false
    if exception.class == MultiJson::DecodeError
      [422, { 'Content-Type' => Mime::JSON }, ['{ "error" : "Invalid JSON" }']]
    else
      # force format to application/json
      env['HTTP_ACCEPT'] = Mime::JSON
      render_exception(env, exception)
    end
  end
end
