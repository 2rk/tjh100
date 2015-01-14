require 'spec_helper'

describe "guests/index" do
  before(:each) do
    assign(:guests, [
      stub_model(Guest,
        :party_id => 1,
        :user_id => 1
      ),
      stub_model(Guest,
        :party_id => 1,
        :user_id => 1
      )
    ])
  end

  it "renders a list of guests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
