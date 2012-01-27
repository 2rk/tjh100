require 'spec_helper'

describe "selections/index" do
  before(:each) do
    assign(:selections, [
      stub_model(Selection,
        :user => nil,
        :song => nil,
        :number_one => false
      ),
      stub_model(Selection,
        :user => nil,
        :song => nil,
        :number_one => false
      )
    ])
  end

  it "renders a list of selections" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
