def test_chatspry_identifier
  ENV.fetch "CHATSPRY_TEST_IDENTIFIER"
end

def test_chatspry_passphrase
  ENV.fetch "CHATSPRY_TEST_PASSPHRASE"
end

def test_chatspry_token
  ENV.fetch "CHATSPRY_TEST_TOKEN", "x" * 21
end

def test_chatspry_client_id
  ENV.fetch "CHATSPRY_TEST_CLIENT_ID", "x" * 26
end

def test_chatspry_client_secret
  ENV.fetch "CHATSPRY_TEST_CLIENT_SECRET", "x" * 32
end