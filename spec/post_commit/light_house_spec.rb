require File.dirname(__FILE__) + "/../spec_helper"

describe PostCommit::Hooks::LightHouse do
  before do
    @url = "http://mycompany.lighthouseapp.com/projects/666/messages.json"
    subject.authorize :subdomain => "mycompany", :token => "abc", :project => 666
  end

  it "should instantiate hook" do
    hook = post_commit(:lighthouse) {}
    hook.should be_an_instance_of(PostCommit::Hooks::LightHouse)
  end

  it "should recover from unknown exceptions" do
    Net::HTTP.should_receive(:new).and_raise(Exception)
    subject.post("Some title", "Some message").should be_false
  end

  it "should post notification" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"], :body => body("lighthouse.json"))
    subject.post("Some title", "Some message")
    FakeWeb.should have_requested(:post, @url)
  end

  it "should return response as hash" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"], :body => body("lighthouse.json"))
    response = subject.post("Some title", "Some message")
    response.should be_an_instance_of(Hash)
  end

  it "should return false when post notification fails" do
    FakeWeb.register_uri(:post, @url, :status => ["401", "Unauthorized"])
    subject.post("Some title", "Some message").should be_false
  end

  it "should set post data" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"], :body => body("lighthouse.json"))
    subject.post("Some title", "Some message")
    body = JSON.parse(subject.request.body)

    body["message"]["title"].should == "Some title"
    body["message"]["body"].should == "Some message"
  end

  it "should set headers" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"], :body => body("lighthouse.json"))
    subject.post("Some title", "Some message")

    subject.request["X-LighthouseToken"].should == "abc"
  end
end
