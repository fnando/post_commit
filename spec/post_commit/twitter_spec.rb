require File.dirname(__FILE__) + "/../spec_helper"

describe PostCommit::Hooks::Twitter do
  before do
    subject.authorize :username => "johndoe", :password => "test"
  end

  it "should instantiate hook" do
    hook = post_commit(:twitter) {}
    hook.should be_an_instance_of(PostCommit::Hooks::Twitter)
  end

  it "should raise when an invalid type is specified" do
    doing { subject.post("Invalid", :type => :invalid) }.should raise_error(PostCommit::InvalidOptionError)
  end

  it "should recover from unknown exceptions" do
    Net::HTTP.should_receive(:new).and_raise(Exception)
    subject.post("Some message").should be_false
  end

  context "public messages" do
    before do
      @url = "http://johndoe:test@twitter.com/statuses/update.json"
      FakeWeb.register_uri(:post, @url, :status => ["200", "OK"], :body => body("twitter.json"))
    end

    it "should set authorization headers" do
      FakeWeb.register_uri(:post, @url, :status => ["200", "OK"], :body => body("twitter.json"))
      subject.post("Some message")

      subject.request["authorization"].should == subject.request.send(:basic_encode, "johndoe", "test")
    end

    it "should call the proper method" do
      subject.should_receive(:status).with("Hi John!", {})
      subject.post("Hi John!", :type => :status)
    end

    it "should be posted" do
      subject.post("Hi Twitter!")
      FakeWeb.should have_requested(:post, @url)
    end

    it "should set post data" do
      subject.post("Hi John!")
      body = CGI.parse(subject.request.body)

      body["status"].to_s.should == "Hi John!"
    end
  end

  context "direct messages" do
    before do
      @url = "http://johndoe:test@twitter.com/direct_messages/new.json"
      FakeWeb.register_uri(:post, @url, :status => ["200", "OK"], :body => body("twitter.json"))
    end

    it "should call the proper method" do
      subject.should_receive(:direct_message).with("Hi John!", :screen_name => "johndoe")
      subject.post("Hi John!", :type => :direct_message, :screen_name => "johndoe")
    end

    it "should be post" do
      subject.post("Hi Twitter!", :type => :direct_message, :screen_name => "johndoe")
      FakeWeb.should have_requested(:post, @url)
    end

    it "should set post data" do
      subject.post("Hi John!", :type => :direct_message, :screen_name => "johndoe")
      body = CGI.parse(subject.request.body)

      body["text"].to_s.should == "Hi John!"
      body["screen_name"].to_s.should == "johndoe"
    end
  end

  it "should return tweet as hash" do
    FakeWeb.register_uri(:post, "http://johndoe:test@twitter.com/statuses/update.json", :status => ["200", "OK"], :body => body("twitter.json"))
    response = subject.post("Hi Twitter!")
    response.should be_an_instance_of(Hash)
  end

  it "should return false when post notification fails" do
    FakeWeb.register_uri(:post, "http://johndoe:test@twitter.com/statuses/update.json", :status => ["401", "Unauthorized"])
    subject.post("Hi Twitter!").should be_false
  end
end
