#require 'spec_helper'
#
#describe "selections/edit" do
#  before(:each) do
#    @selection = assign(:selection, stub_model(Selection,
#      :user => nil,
#      :song => nil,
#      :number_one => false
#    ))
#  end
#
#  it "renders the edit selection form" do
#    render
#
#    # Run the generator again with the --webrat flag if you want to use webrat matchers
#    assert_select "form", :action => selections_path(@selection), :method => "post" do
#      assert_select "input#selection_user", :name => "selection[user]"
#      assert_select "input#selection_song", :name => "selection[song]"
#      assert_select "input#selection_number_one", :name => "selection[number_one]"
#    end
#  end
#end
