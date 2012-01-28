require 'spec_helper'

describe "tweets/new" do
  before(:each) do
    assign(:tweet, stub_model(Tweet,
      :status => "MyString",
      :position => 1,
      :song => nil
    ).as_new_record)
  end

  it "renders new tweet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tweets_path, :method => "post" do
      assert_select "input#tweet_status", :name => "tweet[status]"
      assert_select "input#tweet_position", :name => "tweet[position]"
      assert_select "input#tweet_song", :name => "tweet[song]"
    end
  end
end
