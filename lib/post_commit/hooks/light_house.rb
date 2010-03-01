module PostCommit
  module Hooks
    # To send a Campifire post commit, you have to setup your subdomain, API token and room.
    #
    #   post_commit :lighthouse do
    #     authorize :subdomain => "mycompany", :project => 47533, :token => "TVfD8rB0x1sze8nZ4P1vaO5wOWM"
    #     post "Some title", "Some message"
    #   end
    class LightHouse < Base
      # Post message to Lighthouse.
      #
      #   post "Some nice title", "Hi Lighthouse!"
      def post(title, message)
        @uri = URI.parse("http://#{credentials[:subdomain]}.lighthouseapp.com/projects/#{credentials[:project]}/messages.json")
        http = Net::HTTP.new(uri.host, uri.port)

        @request = Net::HTTP::Post.new(uri.path)
        @request.content_type = "application/json"
        @request["X-LighthouseToken"] = credentials[:token]
        @request.body = {:message => {
          :title => title.to_s,
          :body  => message.to_s
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
