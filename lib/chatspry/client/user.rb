module Chatspry
  class Client
    module User

      def user(id = nil, options = {})
        url = !!id ? "v1/user/#{ id }" : "v1/user"
        get(url, options).user
      end

    end
  end
end