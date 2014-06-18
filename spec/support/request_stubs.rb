def stub_delete(url)
  stub_request(:delete, chatspry_url(url))
end

def stub_get(url)
  stub_request(:get, chatspry_url(url))
end

def stub_head(url)
  stub_request(:head, chatspry_url(url))
end

def stub_patch(url)
  stub_request(:patch, chatspry_url(url))
end

def stub_post(url)
  stub_request(:post, chatspry_url(url))
end

def stub_put(url)
  stub_request(:put, chatspry_url(url))
end

def chatspry_url(url)
  url =~ /^http/ ? url : "http://api.chatspry.dev:8080#{url}"
end