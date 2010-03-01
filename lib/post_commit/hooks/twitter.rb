module PostCommit
  module Hooks
    # To send a Twitter post commit, you have to setup your username and password.
    #
    #   post_commit :twitter do
    #     authorize :username => "johndoe", :password => "test"
    #     post "Some message"
    #   end
    #
    # You can specify the message type. See PostCommit::Hooks::Twitter#post for usage.
    class Twitter < Base
      # Post message to Twitter.
      # You can send public and direct messages.
      #
      #   post "Hi Twitter!"
      #   #=> public message
      #
      #   post "Hi john!", :type => :direct_message, :screen_name => "johndoe"
      #   #=> private message
      #
      #   post "Hi john!", :type => :direct_message, :user_id => 1
      #   #=> private message
      def post(message, options = {})
        options = {:type => :status}.merge(options)

        case options.delete(:type)
        when :status then status(message, options)
        when :direct_message then direct_message(message, options)
        else
          raise PostCommit::InvalidOptionError, "Twitter's message type should be either :status or :direct_message"
        end
      end

      private
        # Send a public message
        def status(message, options = {})
          _request "http://twitter.com/statuses/update.json", options.merge(:status => message)
        end

        # Send a private message.
        # The user you're notifying should be following you.
        def direct_message(message, options = {})
          _request "http://twitter.com/direct_messages/new.json", options.merge(:text => message)
        end

        # Send message to the specified url
        def _request(url, options = {})
          @uri = URI.parse(url)
          http = Net::HTTP.new(uri.host, uri.port)

          @request = Net::HTTP::Post.new(uri.path)
          @request.basic_auth credentials[:username], credentials[:password]
          @request.form_data = options

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
