require File.dirname(__FILE__) + "/../spec_helper"

describe PostCommit::Hooks::Basecamp do
  before do
    @url = "http://abc:x@mycompany.basecamphq.com/projects/666/posts.xml"
    subject.authorize :subdomain => "mycompany", :token => "abc", :project => 666
  end

  it "should instantiate hook" do
    hook = post_commit(:basecamp) {}
    hook.should be_an_instance_of(PostCommit::Hooks::Basecamp)
  end

  it "should post notification" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"])
    subject.post("Some title", "Some message")
    FakeWeb.should have_requested(:post, @url)
  end

  it "should post notification to secure url" do
    @url = "https://abc:x@mycompany.basecamphq.com/projects/666/posts.xml"
    subject.authorize :subdomain => "mycompany", :token => "abc", :project => 666, :ssl => true
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"])
    subject.post("Some title", "Some message")

    subject.uri.to_s.should match(/^https:/)
  end

  it "should return true when message is posted" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"])
    subject.post("Some title", "Some message").should be_true
  end

  it "should return false when post notification fails" do
    FakeWeb.register_uri(:post, @url, :status => ["401", "Unauthorized"])
    subject.post("Some title", "Some message").should be_false
  end

  it "should set authorization headers" do
    FakeWeb.register_uri(:post, @url, :status => ["201", "Created"])
    subject.post("Some title", "Some message")

    subject.request["authorization"].should == subject.request.send(:basic_encode, "abc", "x")
  end
end
