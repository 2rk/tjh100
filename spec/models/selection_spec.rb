require 'spec_helper'

describe Selection do
  describe ".toggle_number_one" do
    before do
      @user_10 = Factory(:user)
      @user_20 = Factory(:user)
      @selection_11 = Factory(:selection, user: @user_10, number_one: true)
      @selection_12 = Factory(:selection, user: @user_10)
      @selection_13 = Factory(:selection, user: @user_10)
      @selection_21 = Factory(:selection, user: @user_20)
      @selection_22 = Factory(:selection, user: @user_20, number_one: true)

    end

    it("has number_one set for user 10") { @selection_11.reload.number_one.should be_true }
    it("has number_one set for user 20") { @selection_22.reload.number_one.should be_true }

    context "change number_one" do
      before { @selection_13.update_attributes(:number_one => true) }

      it("should set number_one") { @selection_13.reload.number_one.should be_true }
      it("should unset previous number_one") { @selection_11.reload.number_one.should be_false }
      it("should not unset other users number_one") { @selection_22.reload.number_one.should be_true }
    end
  end
end
