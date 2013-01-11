require 'spec_helper'

describe "songs/show" do
  before(:each) do
    @song = assign(:song, stub_model(Song,
      :name => "Name",
      :artist => "Artist",
      :position => 1
    ))
  end

  it "renders attributes in <p>" do
  end
end
