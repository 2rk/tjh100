require 'spec_helper'

describe Song do
  it("should be valid?") { Factory(:song).should be_valid }

  it("not allow blank name") { FactoryGirl.build(:song, :name => "").should_not be_valid }
  it("not allow blank artist") { FactoryGirl.build(:song, :artist => "").should_not be_valid }

  let(:song) { Factory(:song)}
  describe ".name_and_artist" do
    it "should return name & artist" do
      song.name_and_artist.should == "#{song.name} - #{song.artist}"
    end
  end
end
