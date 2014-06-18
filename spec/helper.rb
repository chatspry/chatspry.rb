require "json"
require "chatspry"
require "rspec"
require "webmock/rspec"

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

require "support/fixture_configuration"
require "support/environment_defaults"
require "support/request_stubs"

