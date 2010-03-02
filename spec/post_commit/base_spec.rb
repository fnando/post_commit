require File.dirname(__FILE__) + "/../spec_helper"

describe PostCommit::Hooks::Base do
  it "should raise when trying to call abstract method" do
    doing { subject.post }.should raise_error(PostCommit::AbstractMethodError)
  end

  context "convert to params" do
    it "should convert flat hash"
    it "should convert multi-level hash"
  end

  context "convert to xml" do
    it "should convert flat hash" do
      data = {:chars => {:a => 1, :b => 2}}
      xml = Nokogiri::XML(subject.convert_to_xml(data))

      xml.at("chars > a").inner_text.should == "1"
      xml.at("chars > b").inner_text.should == "2"
    end

    it "should convert multi-level hash" do
      data = {
        :chars => {
          :a => {:lowercase => "a", :uppercase => "A"}
        }
      }
      xml = Nokogiri::XML(subject.convert_to_xml(data))

      xml.at("chars > a > lowercase").inner_text.should == "a"
      xml.at("chars > a > uppercase").inner_text.should == "A"
    end
  end
end
