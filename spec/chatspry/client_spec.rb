require "helper"

describe Chatspry::Client do

  before { Chatspry.reset! }
  after { Chatspry.reset! }

  describe "module configuration" do

    before do
      Chatspry.reset!
      Chatspry.configure do |config|
        Chatspry::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after { Chatspry.reset! }

    it "inherits the module configuration" do
      client = Chatspry::Client.new
      Chatspry::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end

    describe "with class level configuration" do

      let!(:opts) do
        @opts = {
          connection_options: {
            ssl: { verify: false }
          },
          identifier: "zeeraw",
          passphrase: "SecretPass1234!"
        }
      end

      it "overrides module configuration" do

        client = Chatspry::Client.new(opts)

        expect(client.identifier).to eq("zeeraw")
        expect(client.instance_variable_get(:"@passphrase")).to eq("SecretPass1234!")
        expect(client.client_id).to eq(Chatspry.client_id)

      end

      it "can set configuration after initialization" do

        client = Chatspry::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end

        expect(client.identifier).to eq("zeeraw")
        expect(client.instance_variable_get(:"@passphrase")).to eq("SecretPass1234!")
        expect(client.client_id).to eq(Chatspry.client_id)

      end

      it "masks passphrases on inspect" do
        client = Chatspry::Client.new(@opts)
        inspected = client.inspect
        expect(inspected).not_to include("SecretPass1234!")
      end

      it "masks tokens on inspect" do
        client = Chatspry::Client.new(:access_token => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).not_to eq("87614b09dd141c22800f96f11737ade5226d7ba8")
      end

      it "masks client secrets on inspect" do
        client = Chatspry::Client.new(:client_secret => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).not_to eq("87614b09dd141c22800f96f11737ade5226d7ba8")
      end

    end
  end

  describe "authentication" do

    let!(:client) { Chatspry.client }
    before { Chatspry.reset! }

    describe "with module level config" do

      before { Chatspry.reset! }

      it "sets basic auth creds with .configure" do

        Chatspry.configure do |config|
          config.identifier = "berwyn"
          config.passphrase = "canIhazCheezburgs"
        end

        expect(Chatspry.client).to be_basic_authenticated
      end

      it "sets basic auth creds with module methods" do

        Chatspry.identifier = "berwyn"
        Chatspry.passphrase = "canIhazCheezburgs"

        expect(Chatspry.client).to be_basic_authenticated
      end

      it "sets oauth token with .configure" do

        Chatspry.configure do |config|
          config.access_token = "d255197b4937b385eb63d1f4677e3ffee61fbaea"
        end

        expect(Chatspry.client).not_to be_basic_authenticated
        expect(Chatspry.client).to be_token_authenticated
      end

      it "sets oauth token with module methods" do
        Chatspry.access_token = "d255197b4937b385eb63d1f4677e3ffee61fbaea"

        expect(Chatspry.client).not_to be_basic_authenticated
        expect(Chatspry.client).to be_token_authenticated
      end

      it "sets oauth application creds with .configure" do

        Chatspry.configure do |config|
          config.client_id = '97b4937b385eb63d1f46'
          config.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end

        expect(Chatspry.client).not_to be_basic_authenticated
        expect(Chatspry.client).not_to be_token_authenticated
        expect(Chatspry.client).to be_application_authenticated
      end

      it "sets oauth token with module methods" do

        Chatspry.client_id = "97b4937b385eb63d1f46"
        Chatspry.client_secret = "d255197b4937b385eb63d1f4677e3ffee61fbaea"

        expect(Chatspry.client).not_to be_basic_authenticated
        expect(Chatspry.client).not_to be_token_authenticated
        expect(Chatspry.client).to be_application_authenticated
      end

    end

    describe "with class level config" do

      it "sets basic auth creds with .configure" do

        client.configure do |config|
          config.identifier = "aethe"
          config.passphrase = "WhatIsWithThesePonies?"
        end

        expect(client).to be_basic_authenticated
      end

      it "sets basic auth creds with instance methods" do
        client.identifier = "aethe"
        client.passphrase = "WhatIsWithThesePonies?"
        expect(client).to be_basic_authenticated
      end

      it "sets oauth token with .configure" do
        client.access_token = "d255197b4937b385eb63d1f4677e3ffee61fbaea"
        expect(client).not_to be_basic_authenticated
        expect(client).to be_token_authenticated
      end

      it "sets oauth token with instance methods" do
        client.access_token = "d255197b4937b385eb63d1f4677e3ffee61fbaea"
        expect(client).not_to be_basic_authenticated
        expect(client).to be_token_authenticated
      end

      it "sets oauth application creds with .configure" do

        client.configure do |config|
          config.client_id = "97b4937b385eb63d1f46"
          config.client_secret = "d255197b4937b385eb63d1f4677e3ffee61fbaea"
        end

        expect(client).not_to be_basic_authenticated
        expect(client).not_to be_token_authenticated
        expect(client).to be_application_authenticated
      end

      it "sets oauth token with module methods" do
        client.client_id = "97b4937b385eb63d1f46"
        client.client_secret = "d255197b4937b385eb63d1f4677e3ffee61fbaea"

        expect(client).not_to be_basic_authenticated
        expect(client).not_to be_token_authenticated
        expect(client).to be_application_authenticated
      end

    end

    describe "when token authenticated", :vcr do

      it "makes authenticated calls" do
        client = oauth_client

        root_request = stub_get("/").with(
          headers: { authorization: "Bearer #{test_chatspry_token}" }
        )

        client.get("/")
        assert_requested root_request
      end

      it "fetches and memorizes identifier" do
        client = oauth_client

        expect(client.identifier).to eq(test_chatspry_identifier)
        assert_requested :get, chatspry_url("/v1/user")
      end

    end

    describe "when application authenticated" do
      it "makes authenticated calls" do
        client = Chatspry.client
        client.client_id     = '97b4937b385eb63d1f46'
        client.client_secret = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'

        root_request = stub_get("/?client_id=97b4937b385eb63d1f46&client_secret=d255197b4937b385eb63d1f4677e3ffee61fbaea")
        client.get("/")
        assert_requested root_request
      end
    end

  end

  describe ".connection" do

    before { Chatspry.reset! }

    it "acts like a Faraday connection" do
      expect(Chatspry.client.connection).to be_kind_of Faraday::Connection
    end

    it "caches the connection" do
      connection = Chatspry.client.connection
      expect(connection.object_id).to eq(Chatspry.client.connection.object_id)
    end

  end

  describe ".get", :vcr do

    before(:each) { Chatspry.reset! }

    it "handles query params" do
      Chatspry.get "/", foo: "bar"
      assert_requested :get, "http://api.chatspry.dev:8080?foo=bar", accept: "text/html"
    end

    it "handles headers" do
      request = stub_get("/zen").with(
        query: { foo: "bar" }, headers: {
          accept: "text/plain"
        }
      )

      Chatspry.get "/zen", foo: "bar", accept: "text/plain"
      assert_requested request
    end

  end

  describe ".head", :vcr do

    before(:each) { Chatspry.reset! }

    it "handles query params" do
      Chatspry.head "/", foo: "bar"
      assert_requested :head, "http://api.chatspry.dev:8080?foo=bar"
    end

    it "handles headers" do
      request = stub_head("/zen").with(
        query: { foo: "bar" }, headers: {
          accept: "text/plain"
        }
      )

      Chatspry.head "/zen", foo: "bar", accept: "text/plain"
      assert_requested request

    end
  end
end