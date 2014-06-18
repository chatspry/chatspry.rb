module Chatspry

  module Configurable

    attr_accessor :access_token, :client_id, :client_secret,
                  :default_media_type, :connection_options,
                  :middleware, :user_agent, :proxy

    attr_writer :identifier, :passphrase, :web_endpoint, :api_endpoint

    class << self

      def keys
        @keys ||= [
          :access_token,
          :client_id,
          :client_secret,
          :identifier,
          :passphrase,

          :web_endpoint,
          :api_endpoint,

          :default_media_type,
          :connection_options,

          :middleware,
          :user_agent,
          :proxy
        ]
      end
    end

    def configure
      yield self
    end

    def reset!
      Chatspry::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Chatspry::Default.options[key])
      end
      self
    end
    alias setup reset!

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    def web_endpoint
      File.join(@web_endpoint, "")
    end

    def identifier
      @identifier ||= begin
        user.handle if token_authenticated?
      end
    end

    def passphrase
      @passphrase
    end

  private

    def options
      Hash[Chatspry::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

  end
end