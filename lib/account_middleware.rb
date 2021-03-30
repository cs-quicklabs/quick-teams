class AccountMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    _, account_id, request_path = env["REQUEST_PATH"].split("/", 3)

    if account_id =~ /\d+/
      if account = Account.find_by(id: account_id)
        Current.account = account
        ActsAsTenant.current_tenant = account
      else
        return [302, { "Location" => "/" }, []]
      end

      env["SCRIPT_NAME"] = "/#{account_id}"
      env["PATH_INFO"] = "/#{request_path}"
      env["REQUEST_PATH"] = "/#{request_path}"
      env["REQUEST_URI"] = "/#{request_path}"
    end

    status, headers, body = @app.call(env)
    [status, headers, body]
  end
end
