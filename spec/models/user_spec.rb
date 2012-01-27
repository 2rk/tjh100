require 'spec_helper'

describe User do
  describe ".max_selected" do
    before do
      @user_10 = Factory(:user)
      @selections = FactoryGirl.create_list(:selection, Selection::SELECTION_QTY - 1, user: @user_10)
    end

    it("should not be set") { @user_10.max_selections.should be_false }
    it "should not be set if equal" do
      Factory(:selection, user: @user_10)
      @user_10.max_selections.should be_true
    end
    it "should not be set if above" do
      Factory(:selection, user: @user_10)
      Factory(:selection, user: @user_10)
      @user_10.max_selections.should be_true
    end
  end
end
