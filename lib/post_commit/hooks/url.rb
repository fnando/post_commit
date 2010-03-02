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
    #
    # You can post data encoded as JSON or XML. Just set the <tt>:data_type</tt> option.
    #
    #   post_commit :url do
    #     set :data_type, :json
    #     set :data_type, :xml
    #   end
    #
    # To post a XML, your params hash need to be a multi-level hash. For instance, the hash
    # <tt>{:message => { :title => "Some title", :body => "Some message" }}</tt> will be converted to
    #
    #   <message>
    #     <title>Some title</title>
    #     <body>Some message</body>
    #   </message>
    #
    # <b>Gotcha:</b> to send a normal POST, you have to specify a flat hash. So <tt>{:a => 1}</tt> is ok,
    # but <tt>{:a => {:b => 1}}</tt> will fail.
    class URL < Base
      # Post data to an arbitrary URL.
      #
      #   post "http://example.com", :message => "Post commit", :service => "yourapp"
      def post(url, params = {})
        @uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)

        @request = Net::HTTP::Post.new(uri.path)

        case options[:data_type]
        when :json then
          @request.content_type = "application/json"
          @request.body = params.to_json
        when :xml then
          @request.content_type = "application/xml"
          @request.body = convert_to_xml(params)
        else
          @request.form_data = convert_to_params(params)
        end

        @request.basic_auth credentials[:username], credentials[:password] if credentials[:username]
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
