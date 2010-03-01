require File.dirname(__FILE__) + "/../spec_helper"

describe PostCommit::Hooks::Base do
  it "should raise when trying to call abstract method" do
    doing { subject.post }.should raise_error(PostCommit::AbstractMethodError)
  end
end
