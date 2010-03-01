module PostCommit
  module Hooks
    # To send a FriendFeed post commit, you have to setup your username and API token.
    # You can retrieve your API token at https://friendfeed.com/account/api.
    #
    #   post_commit :friendfeed do
    #     authorize :username => "johndoe", :token => "abc"
    #     post "Some message", :url => "http://example.com/"
    #   end
    #
    class FriendFeed < Base
      # Post message to FriendFeed.
      #
      #   post "We're working on it!"
      #   post "Google", :url => "http://google.com"
      def post(message, options = {})
        @uri = URI.parse("http://friendfeed-api.com/v2/entry")
        http = Net::HTTP.new(uri.host, uri.port)

        @request = Net::HTTP::Post.new(uri.path)
        @request.basic_auth credentials[:username], credentials[:token]
        @request.form_data = {
          :body => message,
          :link => options[:url]
        }

        @response = http.request(@request)

        if response.code == "200"
          JSON.parse response.body
        else
          false
        end
      rescue Exception
        false
      end
    end
  end
end
