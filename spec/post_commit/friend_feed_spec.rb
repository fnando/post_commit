require File.dirname(__FILE__) + "/../spec_helper"

describe PostCommit::Hooks::FriendFeed do
  before do
    @url = "http://johndoe:abc@friendfeed-api.com/v2/entry"
    subject.authorize :username => "johndoe", :token => "abc"
  end

  it "should instantiate hook" do
    hook = post_commit(:friendfeed) {}
    hook.should be_an_instance_of(PostCommit::Hooks::FriendFeed)
  end

  it "should post notification" do
    FakeWeb.register_uri(:post, @url, :status => ["200", "OK"], :body => body("friendfeed.json"))
    subject.post("Google", :url => "http://google.com")
    FakeWeb.should have_requested(:post, @url)
  end

  it "should return response as hash" do
    FakeWeb.register_uri(:post, @url, :status => ["200", "OK"], :body => body("friendfeed.json"))
    response = subject.post("Google", :url => "http://google.com")
    response.should be_an_instance_of(Hash)
  end

  it "should return false when post notification fails" do
    FakeWeb.register_uri(:post, @url, :status => ["401", "Unauthorized"])
    subject.post("Some message").should be_false
  end

  it "should set post data" do
    FakeWeb.register_uri(:post, @url, :status => ["200", "OK"], :body => body("friendfeed.json"))
    subject.post("Google", :url => "http://google.com")
    body = CGI.parse(subject.request.body)

    body["body"].to_s.should == "Google"
    body["link"].to_s.should == "http://google.com"
  end

  it "should set authorization headers" do
    FakeWeb.register_uri(:post, @url, :status => ["200", "OK"], :body => body("friendfeed.json"))
    subject.post("Google")

    subject.request["authorization"].should == subject.request.send(:basic_encode, "johndoe", "abc")
  end
end
