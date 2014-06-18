require "json"
require "chatspry"
require "rspec"
require "webmock/rspec"

require "support/fixture_configuration"
require "support/environment_defaults"
require "support/request_stubs"

ENV["CHATSPRY_API_ENDPOINT"] = test_chatspry_api_endpoint

RSpec.configure do |config|

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.default_formatter = "doc" if config.files_to_run.one?

  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

end

def oauth_client
  Chatspry::Client.new(:access_token => test_chatspry_token)
end

