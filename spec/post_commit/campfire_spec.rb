require File.dirname(__FILE__) + "/../spec_helper"

describe PostCommit::Hooks::Campfire do
  before do
    @url = "http://abc:x@mycompany.campfirenow.com/room/666/speak.json"
    subject.authorize :subdomain => "mycompany", :token => "abc", :room => 666
  end

  it "should instantiate hook" do
    hook = post_commit(:campfire) {}
    hook.should be_an_instance_of(PostCommit::Hooks::Campfire)
  end

  it "should post notification" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"], :body => body("campfire.json"))
    subject.post("Hi Campfire!")
    FakeWeb.should have_requested(:post, @url)
  end

  it "should post notification to secure url" do
    @url = "https://abc:x@mycompany.campfirenow.com/room/666/speak.json"
    subject.authorize :subdomain => "mycompany", :token => "abc", :room => 666, :ssl => true
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"], :body => body("campfire.json"))
    subject.post("Hi Campfire!")

    subject.uri.to_s.should match(/^https:/)
  end

  it "should return tweet as hash" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"], :body => body("campfire.json"))
    response = subject.post("Hi Campfire!")
    response.should be_an_instance_of(Hash)
  end

  it "should return false when post notification fails" do
    FakeWeb.register_uri(:post, @url, :status => ["401", "Unauthorized"])
    subject.post("Hi Campfire!").should be_false
  end

  it "should set post data for text message" do
    subject.post("Hi John!", :type => :text)
    body = JSON.parse(subject.request.body)

    body["message"]["type"].to_s.should == "TextMessage"
    body["message"]["body"].to_s.should == "Hi John!"
  end

  it "should set post data for paste message" do
    subject.post("Some pasted code", :type => :paste)
    body = JSON.parse(subject.request.body)

    body["message"]["type"].to_s.should == "PasteMessage"
    body["message"]["body"].to_s.should == "Some pasted code"
  end

  it "should set post data for twitter message" do
    subject.post("http://twitter.com/statuses/johndoe/1234", :type => :twitter)
    body = JSON.parse(subject.request.body)

    body["message"]["type"].to_s.should == "TwitterMessage"
    body["message"]["body"].to_s.should == "http://twitter.com/statuses/johndoe/1234"
  end

  it "should set authorization headers" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"], :body => body("campfire.json"))
    subject.post("Some message")

    subject.request["authorization"].should == subject.request.send(:basic_encode, "abc", "x")
  end
end
