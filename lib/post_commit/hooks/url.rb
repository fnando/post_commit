module PostCommit
  module Hooks
    # To send an URL post commit, you have to set up your URL and, optionally, username and password.
    #
    #   post_commit :url do
    #     post "http://example.com", :message => "Post commit"
    #   end
    #
    # If you need to authorize your request with basic auth, you can set your username and password.
    #
    #   post_commit :url do
    #     authorize :username => "johndoe", :password => "mypass"
    #     post "http://example.com", :message => "Post commit"
    #   end
    class URL < Base
      # Post data to an arbitrary URL. The data should a one-depth hash.
      #
      #   post "http://example.com", :message => "Post commit", :service => "yourapp"
      def post(url, params = {})
        @uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)

        @request = Net::HTTP::Post.new(uri.path)
        @request.basic_auth credentials[:username], credentials[:password] if credentials[:username]
        @request.form_data = params

        @response = http.request(@request)

        if response.code =~ /^2\d+/
          true
        else
          false
        end
      rescue Exception
        false
      end
    end
  end
end
