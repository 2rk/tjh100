class Tweet < ActiveRecord::Base
  belongs_to :song

  before_validation :get_position
  before_save :match_song, :if => :is_position_tweet
  after_save :update_song_position, :if => :song
  validates_presence_of :position

  def match_song
    self.song = Song.find_by_name(parse_song)
  end

  def update_song_position
    song.update_attributes(position: position)
  end

  def parse_position
    status[1..status.index(" ")-1] if is_position_tweet
  end

  def is_position_tweet
    status.first == "#" && position_text =~ /^[0-9]+$/
  end

  def get_position
    self.position = parse_position
  end

  def position_text
    status[1..status.index(" ")-1]
  end

  def parse_song
    start_quote = status.index("- '").to_i+3
    end_quote = status.rindex("'").to_i
    status[start_quote...end_quote] if start_quote < end_quote
  end

  def self.get_feed
    Twitter.user_timeline("triplej", count: 10).each do |tweet|
      Rails.logger.info tweet.text
      self.create(tweet_id: tweet.id, status: tweet.text) unless find_by_tweet_id(tweet.id)
    end
  end
end
