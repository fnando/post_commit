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

  it "should set post data" do
    subject.post(@url, :message => "Some message", :id => 1234)
    body = CGI.parse(subject.request.body)

    body["message"].to_s.should == "Some message"
    body["id"].to_s.should == "1234"
  end
end
