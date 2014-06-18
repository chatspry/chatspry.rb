require "chatspry/version"

module Chatspry

  module Default

    API_ENDPOINT = "http://api.chatspry.dev:8080".freeze
    WEB_ENDPOINT = "http://chatspry.dev:4200".freeze

    MEDIA_TYPE   = "application/json".freeze
    USER_AGENT   = "Chatspry Ruby Gem #{ Chatspry::VERSION }".freeze

    RACK_BUILDER_CLASS = defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder

    MIDDLEWARE = RACK_BUILDER_CLASS.new do |builder|
      builder.adapter Faraday.default_adapter
      builder.request :json

      builder.response :mashify
      builder.response :json, content_type: /\bjson$/
    end

    class << self

      def options
        Hash[Chatspry::Configurable.keys.map{|key| [key, send(key)]}]
      end

      def access_token
        ENV["CHATSPRY_ACCESS_TOKEN"]
      end

      def api_endpoint
        ENV["CHATSPRY_API_ENDPOINT"] || API_ENDPOINT
      end

      def web_endpoint
        ENV["CHATSPRY_WEB_ENDPOINT"] || WEB_ENDPOINT
      end

      def client_id
        ENV["CHATSPRY_CLIENT_ID"]
      end

      def client_secret
        ENV["CHATSPRY_SECRET"]
      end

      def default_media_type
        ENV["CHATSPRY_DEFAULT_MEDIA_TYPE"] || MEDIA_TYPE
      end

      def identifier
        ENV["CHATSPRY_LOGIN"]
      end

      def passphrase
        ENV["CHATSPRY_PASSPHRASE"]
      end

      def user_agent
        ENV["CHATSPRY_USER_AGENT"] || USER_AGENT
      end

      def proxy
        ENV["CHATSPRY_PROXY"]
      end

      def connection_options
        { headers: { accept: default_media_type, user_agent: user_agent } }
      end

      def middleware
        MIDDLEWARE
      end

    end

  end

end