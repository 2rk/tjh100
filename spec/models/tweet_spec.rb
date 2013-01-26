# encoding: utf-8
require 'spec_helper'

describe Tweet do
  it("should be valid") { Factory(:tweet).should be_valid }

  describe "#get_timeline" do
    context "adding tweets" do
      it "only adds position records" do
        Twitter.stub(:user_timeline).and_return([Twitter::Status.new("text" => "This is not a top100 position tweet", "id" => 5)])
        Tweet.get_feed
        Tweet.count.should == 0
      end
      context "add position tweet" do
        before do
          Twitter.stub(:user_timeline).and_return([Twitter::Status.new("text" => "#6 @LanaDelRey - 'Video Games' #Hottest100", "id" => 20)])
          @song_1 = Factory(:song, name: "Video Games")
          Tweet.get_feed
        end
        it("add record") { Tweet.count.should == 1 }
        it("set position to 6") { Tweet.last.position == 6 }
        it("matches song") { Tweet.last.song.should == @song_1 }
      end

      context "multiple" do
        before do
          Twitter.stub(:user_timeline).and_return([
                                                      Twitter::Status.new("text" => "#5 M83 - 'Midnight City' #Hottest100", "id" => 40),
                                                      Twitter::Status.new("text" => "#6 @LanaDelRey - 'Video Games' #Hottest100", "id" => 30),
                                                      Twitter::Status.new("text" => "#7 San Cisco (@SanCiscoMusic) - 'Awkward' #Hottest100", "id" => 20)
                                                  ])
          Tweet.get_feed
        end
        it("should have 3 records") { Tweet.count.should == 3 }
        it("should have ids") { Tweet.all.map(&:tweet_id).should == [40, 30, 20] }
        it "should not add exiting tweet" do
          Twitter.stub(:user_timeline).and_return([Twitter::Status.new("text" => "#6 @LanaDelRey - 'Video Games' #Hottest100", "id" => 20)])
          Tweet.get_feed
          Tweet.count.should == 3
        end
        it "should add non-exiting tweet" do
          Twitter.stub(:user_timeline).and_return([Twitter::Status.new("text" => "#4 @BoyAndBear - 'Feeding Line' #Hottest100", "id" => 50)])
          Tweet.get_feed
          Tweet.count.should == 4
        end
      end
    end

    context ".is_position_tweet" do
      it("is a position") { Tweet.create(status: "#4 @BoyAndBear - 'Feeding Line' #Hottest100").is_position_tweet.should be_true }
      it("is not a position without a number") { Tweet.create(status: "#This is not a top100 position tweet").is_position_tweet.should be_false }
      it("is not a position with # and no number") { Tweet.create(status: "# This is not a top100 position tweet").is_position_tweet.should be_false }
      it("is not a position without starting with a hash") { Tweet.create(status: "This is not a top100 position tweet").is_position_tweet.should be_false }
    end
    context ".position" do
      it("is position 4") { Tweet.create(status: "#4 abc").position.should == 4 }
      it("is position 11") { Tweet.create(status: "#11 abc").position.should == 11 }
      it("is position 1") { Tweet.create(status: "#1 abc").position.should == 1 }
    end
    context ".parse_song" do
      it("is 'feeding Line'") { Tweet.create(status: "#4 @BoyAndBear - 'Feeding Line' #Hottest100").parse_song.should == "Feeding Line" }
      it("is 'Somebody That I Used To Know (Ft. Kimbra)'") { Tweet.create(status: "#1 @Gotye - 'Somebody That I Used To Know (Ft. Kimbra)' #Hottest100").parse_song.should == "Somebody That I Used To Know (Ft. Kimbra)" }
      it("is handle songs with punctuation (')") { Tweet.create(status: "#4 @BoyAndBear - 'Feeding Line's' #Hottest100").parse_song.should == "Feeding Line's" }
    end
    context ".match_song" do
      before do
        @song_1 = Factory(:song, :name => "Fineshrine")
        @song_2 = Factory(:song, :name => "Somebody That I Used's To Know (Ft. Kimbra)")
        @song_3 = Factory(:song, :name => "a song {featuring someone}")
      end
      it("is 'feeding Line'") { Tweet.create(status: "#85 @PURITY_RING – ‘Fineshrine’ #Hottest100").song.should == @song_1 }
      it("is 'feeding Line'") { Tweet.create(status: "#85 @PURITY_RING – ‘a song’ #Hottest100").song.should == @song_3 }
      it("is 'Somebody That I Used To Know (Ft. Kimbra)'") { Tweet.create(status: "#1 @Gotye - 'Somebody That I Used's To Know (Ft. Kimbra)' #Hottest100").song.should == @song_2 }
      it "should update Song position" do
        Tweet.create(status: "#4 @BoyAndBear - 'Feeding Line' #Hottest100")
        @song_1.reload.position.should == 4
      end
    end
  end
end

=begin
Example Tweets
"#1 @Gotye - 'Somebody That I Used To Know (Ft. Kimbra)' #Hottest100"
"#2 @TheBlackKeys - 'Lonely Boy' #Hottest100"
"#3 @Matt_Corby - 'Brother' #Hottest100"
"#4 @BoyAndBear - 'Feeding Line' #Hottest100"
"#5 M83 - 'Midnight City' #Hottest100"
"#6 @LanaDelRey - 'Video Games' #Hottest100"
"#7 San Cisco (@SanCiscoMusic) - 'Awkward' #Hottest100"

=end