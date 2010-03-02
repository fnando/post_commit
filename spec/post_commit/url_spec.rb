require File.dirname(__FILE__) + "/../spec_helper"

describe PostCommit::Hooks::URL do
  before do
    @url = "http://example.com/some/url"
  end

  it "should instantiate hook" do
    hook = post_commit(:url) {}
    hook.should be_an_instance_of(PostCommit::Hooks::URL)
  end

  it "should recover from unknown exceptions" do
    Net::HTTP.should_receive(:new).and_raise(Exception)
    subject.post(@url, :message => "Some message").should be_false
  end

  it "should set authorization headers" do
    @url = "http://johndoe:mypass@example.com/some/url"
    FakeWeb.register_uri(:post, @url, :status => ["200", "OK"])

    subject.authorize :username => "johndoe", :password => "mypass"
    subject.post(@url, :message => "Some message")

    subject.request["authorization"].should == subject.request.send(:basic_encode, "johndoe", "mypass")
  end

  it "should be posted" do
    FakeWeb.register_uri(:post, @url, :status => ["200", "OK"])
    subject.post(@url, :message => "Some message")
    FakeWeb.should have_requested(:post, @url)
  end

  it "should be successful with any success status" do
    FakeWeb.register_uri(:post, @url, [
      {:status => ["200", "OK"]},
      {:status => ["201", "Created"]}
    ])

    subject.post(@url, :message => "Some message").should be_true
    subject.post(@url, :message => "Some message").should be_true
  end

  it "should return false with any status other than 2xx" do
    FakeWeb.register_uri(:post, @url, :status => ["401", "Unauthorized"])

    subject.post(@url, :message => "Some message").should be_false
  end

  it "should set post data" do
    subject.post(@url, :message => "Some message", :id => 1234)
    body = CGI.parse(subject.request.body)

    body["message"].to_s.should == "Some message"
    body["id"].to_s.should == "1234"
  end

  context "data type" do
    context "JSON string" do
      before do
        subject.set :data_type, :json
        subject.post(@url, :message => {:title => "Some title", :body => "Some message"})
      end

      it "should encode body" do
        body = JSON.parse(subject.request.body)

        body["message"]["title"].should == "Some title"
        body["message"]["body"].should == "Some message"
      end

      it "should set headers" do
        subject.request.content_type.should == "application/json"
      end
    end

    context "XML string" do
      before do
        subject.set :data_type, :xml
        subject.post(@url, :message => {:title => "Some title", :body => "Some message"})
      end

      it "should encode body" do
        xml = Nokogiri::XML(subject.request.body)
        xml.at("message > title").inner_text.should == "Some title"
        xml.at("message > body").inner_text.should == "Some message"
      end

      it "should set headers" do
        subject.request.content_type.should == "application/xml"
      end
    end
  end
end
