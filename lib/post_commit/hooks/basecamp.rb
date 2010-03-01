module PostCommit
  module Hooks
    # To send a Basecamp post commit, you have to setup your subdomain, API token and project.
    #
    #   post_commit :basecamp do
    #     authorize :subdomain => "mycompany", :token => "TVfD8rB0x1sze8nZ4P1vaO5wOWM", :project => 666, :ssl => true
    #     post "Some title", "Some message"
    #   end
    #
    class Basecamp < Base
      # Post message to Basecamp.
      #
      #   post "Some title", "Some message"
      def post(title, message)
        protocol = credentials[:ssl] ? "https" : "http"
        @uri = URI.parse("#{protocol}://#{credentials[:subdomain]}.basecamphq.com/projects/#{credentials[:project]}/posts.xml")
        http = Net::HTTP.new(uri.host, uri.port)

        @request = Net::HTTP::Post.new(uri.path)
        @request.basic_auth credentials[:token], "x"
        @request.content_type = "application/xml"
        @request.body = <<-TXT
        <post>
          <title><![CDATA[#{title}]]></title>
          <body><![CDATA[#{message}]]></body>
        </post>
        TXT

        @response = http.request(@request)

        if @response.code == "201"
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
