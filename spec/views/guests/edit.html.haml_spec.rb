require 'spec_helper'

describe "guests/edit" do
  before(:each) do
    @guest = assign(:guest, stub_model(Guest,
      :party_id => 1,
      :user_id => 1
    ))
  end

  it "renders the edit guest form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => guests_path(@guest), :method => "post" do
      assert_select "input#guest_party_id", :name => "guest[party_id]"
      assert_select "input#guest_user_id", :name => "guest[user_id]"
    end
  end
end
