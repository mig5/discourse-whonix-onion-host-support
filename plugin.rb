# name: discourse-whonix-onion-host-support
# about: load Whonix site on onion if used
# version: 0.1
# authors: Miguel Jacq

::ONION_HOST = "forums.dds6qkxpwdeubwucdiaord2xgbbeyds25rbsgr73tbfpqpt4a6vjwsyd.onion"
::CLEAR_HOST = "forums.whonix.org"

after_initialize do

  # got to patch this class to allow more hostnames
  class ::Middleware::EnforceHostname
    def call(env)
      hostname = env[Rack::Request::HTTP_X_FORWARDED_HOST].presence || env[Rack::HTTP_HOST]

      env[Rack::Request::HTTP_X_FORWARDED_HOST] = nil

      if hostname == ::ONION_HOST
        env[Rack::HTTP_HOST] = ::ONION_HOST
      else
        env[Rack::HTTP_HOST] = ::CLEAR_HOST
      end

      @app.call(env)
    end
  end
end
