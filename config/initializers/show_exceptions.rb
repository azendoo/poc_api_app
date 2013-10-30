# encoding: UTF-8
# XXX :
# Override ShowExceptions behavior to render
# pure JSON for exceptions and routing errors.
class ActionDispatch::ShowExceptions
  def call(env)
    status, headers, body = @app.call(env)

    if headers['X-Cascade'] == 'pass'
      raise ActionController::RoutingError, "No route matches #{env['PATH_INFO'].inspect}"
    end

    [status, headers, body]
  rescue Exception => exception
    raise exception if env['action_dispatch.show_exceptions'] == false
    # force response format to application/json
    env['HTTP_ACCEPT'] = Mime::JSON
    render_exception(env, exception)
  end
end
