# encoding: utf-8
class Tweet < ActiveRecord::Base
  belongs_to :song

  before_validation :get_position
  before_save :match_song, :if => :is_position_tweet
  before_save :update_song_position, :if => :song
  validates_presence_of :position

  def match_song

    p "parse_song = '#{parse_song}'"


    self.song = Song.where("name like ?", "#{parse_song}%").first
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
    puts
    p "status = #{status}"
    p "get_positions = #{parse_position}"
    self.position = parse_position
  end

  def position_text
    status[1..status.index(" ")-1]
  end

  def parse_song
    start_quote = (status.index("– ‘") || status.index("– ‘") || status.index("- ‘") || status.index("- ‘") || status.index("- '")).to_i+3

    p "start_quote = #{start_quote}"
    end_quote = (status.rindex('’') || status.rindex("'")).to_i
    p "end_quote = #{end_quote}"
    status[start_quote...end_quote] if start_quote < end_quote
  end

  def self.get_feed
    Twitter.user_timeline("triplej", count: 10).each do |tweet|
      Rails.logger.info "#{tweet.id} '#{tweet.text}'"
      self.create(tweet_id: tweet.id, status: tweet.text) unless find_by_tweet_id(tweet.id)
    end
  end
end
