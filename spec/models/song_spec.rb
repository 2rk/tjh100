require 'spec_helper'

describe Song do
  it("should be valid?") { Factory(:song).should be_valid }

  it("not allow blank name") { FactoryGirl.build(:song, :name => "").should_not be_valid }
  it("not allow blank artist") { FactoryGirl.build(:song, :artist => "").should_not be_valid }
end
