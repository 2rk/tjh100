class Tweet < ActiveRecord::Base
  belongs_to :song

  def self.get_feed
    Twitter.user_timeline("triplej").each do |tweet|
      unless find_by_tweet_id(tweet.id)
        if self.is_position_tweet tweet.text
          self.create(tweet_id: tweet.id, status: tweet.text)
        end
      end
    end
  end

  def self.is_position_tweet text
    text.first == "#" && self.position_text(text) =~ /^[0-9]+$/
  end

  def self.position_text text
    text[1..text.index(" ")-1]
  end

  def self.position text
    self.position_text(text).to_i
  end
end
