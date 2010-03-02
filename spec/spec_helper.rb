$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"

require "rubygems"
require "cgi"
require "post_commit"
require "spec"
require "fakeweb"
require "fakeweb_matcher"
require "nokogiri"

FakeWeb.allow_net_connect = false

module SpecHelpers
  def body(filename)
    File.read(File.dirname(__FILE__) + "/resources/responses/#{filename}")
  end
end

Spec::Runner.configure do |config|
  config.prepend_before :each do
    FakeWeb.clean_registry
  end

  config.include SpecHelpers
end

# Create an alias for lambda
alias :doing :lambda
