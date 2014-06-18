require "faraday"
require "faraday_middleware"
require "chatspry/configurable"
require "chatspry/authentication"
require "chatspry/client/user"

module Chatspry

  class Client

    include Chatspry::Authentication
    include Chatspry::Configurable
    include Chatspry::Client::User

    def initialize(options = {})
      Chatspry::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Chatspry.instance_variable_get(:"@#{key}"))
      end
    end

    def same_options?(opts)
      opts.hash == options.hash
    end

    def inspect
      string = ["<Chatspry::Client"]
      string << "identifier: #{ @identifier }" if @identifier
      string << "passphrase: #{ "*******" }" if @passphrase
      string << "access_token: #{'*'*56}#{@access_token[56..-1] }" if @access_token
      string << "client_secret: #{ '*'*36 }#{@client_secret[36..-1] }" if @client_secret
      string = string.join " "
      string.concat ">"
    end

    def connection
      @connection ||= Faraday.new(faraday_options) do |conn|

        conn.headers[:accept] = default_media_type
        conn.headers[:user_agent] = user_agent

        if token_authenticated?
          conn.authorization "Bearer", @access_token
        elsif application_authenticated?
          conn.params = conn.params.merge application_authentication
        end

      end

    end

    def get(url, options = {})
      request :get, url, options
    end

    def head(url, options = {})
      request :head, url, options
    end

    def post(url, options = {})
      request :post, url, options
    end

    def put(url, options = {})
      request :put, url, options
    end

    def patch(url, options = {})
      request :patch, url, options
    end

    def delete(url, options = {})
      request :delete, url, options
    end

    def request(method, path, options = {})
      headers = options.delete(:headers) || {}
      if accept = options.delete(:accept)
        headers[:accept] = accept
      end

      query = options.delete(:query) || {}
      query = options.merge(query)

      @last_response = response = connection.send(method, URI::Parser.new.escape(path.to_s), query, headers)
      response.body
    end

    def last_response
      @last_response if defined? @last_response
    end

    def faraday_options
      opts = connection_options

      opts[:builder] = middleware if middleware
      opts[:proxy] = proxy if proxy
      opts[:url] = api_endpoint

      return opts
    end

  end

end