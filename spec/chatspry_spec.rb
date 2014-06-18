require 'helper'

describe Chatspry do

  before { Chatspry.reset! }
  after { Chatspry.reset! }

  it "sets defaults" do
    Chatspry::Configurable.keys.each do |key|
      expect(Chatspry.instance_variable_get(:"@#{key}")).to eq( Chatspry::Default.send(key) )
    end
  end

  describe ".client" do

    it "creates an Chatspry::Client" do
      expect(Chatspry.client).to be_kind_of Chatspry::Client
    end

    it "caches the client when the same options are passed" do
      expect(Chatspry.client).to eq(Chatspry.client)
    end

    it "returns a fresh client when options are not the same" do
      client = Chatspry.client
      Chatspry.access_token = "87614b09dd141c22800f96f11737ade5226d7ba8"
      client_two = Chatspry.client
      client_three = Chatspry.client
      expect(client).not_to eq(client_two)
      expect(client_three).to eq(client_two)
    end

  end

  describe ".configure" do

    Chatspry::Configurable.keys.each do |key|
      it "sets the #{ key.to_s.gsub('_', ' ') }" do
        Chatspry.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Chatspry.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end

  end

end