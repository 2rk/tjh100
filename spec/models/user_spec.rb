require 'spec_helper'

describe User do

  let(:user) { Factory(:user) }
  let(:song) { Factory(:song) }

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


  describe ".calculate_number1" do
    before do
      @user_10 = FactoryGirl.create(:user)
      @user_20 = FactoryGirl.build(:user)
      @user_30 = FactoryGirl.build(:user)
      @song_1 = Factory(:song, position: 100)
      @song_2 = Factory(:song, position: 5)
      @song_3 = Factory(:song, position: 1)
      Factory(:selection, user: @user_10, song: @song_1)
      @selection_1 = Factory(:selection, user: @user_10, song: @song_3 )
      Factory(:selection, user: @user_20, song: @song_1)
      Factory(:selection, user: @user_20, song: @song_2, number_one: true)
      Factory(:selection, user: @user_10, song: @song_2)
      Factory(:selection, user: @user_30, song: @song_1)
      Factory(:selection, user: @user_30, song: @song_2)
    end

    it "1 person picked and not number one" do
      User.calculate_number1
      @user_10.reload.score.should == 0
      @user_20.reload.score.should == 50
    end
    it "1 person picked and was number one" do
      @selection_1.update_attribute(:number_one, true)
      User.calculate_number1
      @user_10.reload.score.should == 50
      @user_20.reload.score.should == 0
    end
    it "2 people picked and #1" do
      Factory(:selection, user: @user_10, song: @song_3, number_one: true)
      User.calculate_number1
      @user_10.reload.score.should == 50
      @user_20.reload.score.should == 50
    end
    it "2 people picked not #1 and one other not highest" do
      Factory(:selection, user: @user_10, song: @song_2, number_one: true)
      User.calculate_number1
      @user_10.reload.score.should == 50
      @user_20.reload.score.should == 50
      @user_30.reload.score.should == 0
    end
  end

  describe ".display_picks" do
    context "user" do
      it("when not locked") { Factory(:user).display_picks.should be_false }
      it("when locked") { Factory(:user, locked: true).display_picks.should be_true }
    end
    context "admin" do
      it("display picks") { Factory(:user_admin).display_picks.should be_true }
    end
  end

  describe ".ok_to_submit?" do
    context "no enough selected" do
      before { user.songs = [song] }
      it("should be false") { user.ok_to_submit?.should be_false }
    end
    context "40 selected" do
      before { user.songs = FactoryGirl.create_list(:song, 40) }
      context "#1 is not set" do
        it("should be false") { user.ok_to_submit?.should be_false }
      end
      context "#1 is  set" do
        before do
          user.selections.first.update_attribute(:number_one, true)
        end
        it("should be true") { user.ok_to_submit?.should be_true }
      end
    end
  end
end
