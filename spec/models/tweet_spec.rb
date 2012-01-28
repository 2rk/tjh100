require 'spec_helper'

describe Tweet do
  #it "meme" do
  #  Twitter.user_timeline("triplej", count: 20).each do |x|
  #    p x.text
  #  end
  #end

  describe "#get_timeline" do
    context "adding tweets" do
      it "only adds position records" do
        Twitter.stub(:user_timeline).and_return([Twitter::Status.new("text" => "This is not a top100 position tweet", "id" => 5)])
        Tweet.get_feed
        Tweet.count.should == 0
      end
      it "add position tweet" do
        Twitter.stub(:user_timeline).and_return([Twitter::Status.new("text" => "#6 @LanaDelRey - 'Video Games' #Hottest100", "id" => 20)])
        Tweet.get_feed
        Tweet.count.should == 1
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

    context "#is_position_tweet" do
      it("is a position") { Tweet.is_position_tweet("#4 @BoyAndBear - 'Feeding Line' #Hottest100").should be_true }
      it("is not a position without a number") { Tweet.is_position_tweet("#This is not a top100 position tweet").should be_false }
      it("is not a position with # and no number") { Tweet.is_position_tweet("# This is not a top100 position tweet").should be_false }
      it("is not a position without starting with a hash") { Tweet.is_position_tweet("This is not a top100 position tweet").should be_false }
    end
    context "#position" do
      it("is  position 4") { Tweet.position("#4 abc").should == 4 }
      it("is  position 11") { Tweet.position("#11 abc").should == 11 }
      it("is  position 1") { Tweet.position("#1 abc").should == 1 }
    end
  end
end

=begin
"#1 @Gotye - 'Somebody That I Used To Know (Ft. Kimbra)' #Hottest100"
"#2 @TheBlackKeys - 'Lonely Boy' #Hottest100"
"#3 @Matt_Corby - 'Brother' #Hottest100"
"#4 @BoyAndBear - 'Feeding Line' #Hottest100"
"#5 M83 - 'Midnight City' #Hottest100"
"#6 @LanaDelRey - 'Video Games' #Hottest100"
"#7 San Cisco (@SanCiscoMusic) - 'Awkward' #Hottest100"

=end