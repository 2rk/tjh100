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

  context "score" do
    before do
      @user_10 = Factory(:user)
      @user_20 = Factory(:user)
      @song_1 = Factory(:song, position: 100)
      @song_2 = Factory(:song, position: 90)
      @song_3 = Factory(:song, position: 80)
      Factory(:selection, user: @user_10, song: @song_1)
      Factory(:selection, user: @user_10, song: @song_3)
      Factory(:selection, user: @user_20, song: @song_2)
      Factory(:selection, user: @user_20, song: @song_3)
    end
    it ".calculate_score" do
      @user_10.calculate_score
      @user_10.score.should == 22
    end
    it "#recalculate_scores" do
      User.recalculate_scores
      @user_10.reload.score.should == 22
    end
  end
end
