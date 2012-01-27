require 'spec_helper'

describe "selections/index" do
  it "should not show the remove link" do
    controller.stub!(:current_user).and_return(Factory(:user))
    user = Factory(:user)
    assign(:user, user)
    assign(:selections, FactoryGirl.create_list(:selection, 2, :user => user))
    render

    assert_select "#remove_song", :count => 0
    assert_select "#selection_qty", :text => "2 of #{Selection::SELECTION_QTY}"
  end

  it "should show the remove link when listing own" do
    user = Factory(:user)
    controller.stub!(:current_user).and_return(user)
    assign(:user, user)
    assign(:selections, FactoryGirl.create_list(:selection, 2, :user => user))
    render

    assert_select "#remove_song"
  end
end
