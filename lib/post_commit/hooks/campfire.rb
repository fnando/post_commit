module PostCommit
  module Hooks
    # To send a Campfire post commit, you have to setup your subdomain, API token and room.
    #
    #   post_commit :campfire do
    #     authorize :subdomain => "mycompany", :token => "TVfD8rB0x1sze8nZ4P1vaO5wOWM", :room => 666, :ssl => true
    #     post "Some message"
    #   end
    #
    # You can specify the message type. See PostCommit::Hooks::Campfire#post for usage.
    class Campfire < Base
      MESSAGE_TYPE = {
        :text    => "TextMessage",
        :paste   => "PasteMessage",
        :twitter => "TwitterMessage"
      }

      # Post message to Campfire.
      #
      #   post "Hi Campfire!"
      #   #=> send text message
      #
      #   post "Pasted code", :type => :paste
      #   #=> formatted paste message with more link and scroll bar
      #
      #   post "http://twitter.com/dhh/status/9688523285", :type => :twitter
      #   #=> display the specified Twitter status
      def post(message, options = {})
        options = {:type => :text}.merge(options)
        protocol = credentials[:ssl] ? "https" : "http"
        @uri = URI.parse("#{protocol}://#{credentials[:subdomain]}.campfirenow.com/room/#{credentials[:room]}/speak.json")
        http = Net::HTTP.new(uri.host, uri.port)

        @request = Net::HTTP::Post.new(uri.path)
        @request.basic_auth credentials[:token], "x"
        @request.content_type = "application/json"
        @request.body = {:message => {
          :type => MESSAGE_TYPE[options[:type].to_sym],
          :body => message.to_s
        }}.to_json

        @response = http.request(@request)

        if @response.code == "201"
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
