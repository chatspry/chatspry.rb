require "vcr"

VCR.configure do |c|

  c.configure_rspec_metadata!
  c.filter_sensitive_data("<CHATSPRY_IDENTIFIER>") do
    test_chatspry_identifier
  end

  c.filter_sensitive_data("<CHATSPRY_PASSPHRASE>") do
    test_chatspry_passphrase
  end

  c.filter_sensitive_data("<ACCESS_TOKEN>") do
    test_chatspry_token
  end

  c.filter_sensitive_data("<CHATSPRY_CLIENT_ID>") do
    test_chatspry_client_id
  end

  c.filter_sensitive_data("<CHATSPRY_CLIENT_SECRET>") do
    test_chatspry_client_secret
  end

  # c.before_http_request(:real?) do |request|

  #   next if request.headers['X-Vcr-Test-Repo-Setup']
  #   next unless request.uri.include? test_github_repository

  #   options = {
  #     :headers => {'X-Vcr-Test-Repo-Setup' => 'true'},
  #     :auto_init => true
  #   }

  #   test_repo = "#{test_github_login}/#{test_github_repository}"
  #   if !oauth_client.repository?(test_repo, options)
  #     Octokit.octokit_warn "NOTICE: Creating #{test_repo} test repository."
  #     oauth_client.create_repository(test_github_repository, options)
  #   end

  #   test_org_repo = "#{test_github_org}/#{test_github_repository}"
  #   if !oauth_client.repository?(test_org_repo, options)
  #     Octokit.octokit_warn "NOTICE: Creating #{test_org_repo} test repository."
  #     options[:organization] = test_github_org
  #     oauth_client.create_repository(test_github_repository, options)
  #   end

  # end

  # c.ignore_request do |request|
  #   !!request.headers['X-Vcr-Test-Repo-Setup']
  # end

  c.default_cassette_options = {
    serialize_with: :json,
    preserve_exact_body_bytes: true,
    decode_compressed_response: true,
    record: ENV['TRAVIS'] ? :none : :once
  }

  c.cassette_library_dir =  File.expand_path("../../cassettes", __FILE__)
  c.hook_into :webmock
end

def fixture_path
  File.expand_path("../../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + "/" + file)
end