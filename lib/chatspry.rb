require "chatspry/client"
require "chatspry/default"

module Chatspry

  class << self

    include Chatspry::Configurable

    def client
      @client = Chatspry::Client.new(options) unless defined?(@client) && @client.same_options?(options)
      @client
    end

  private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end

end

Chatspry.setup