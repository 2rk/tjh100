class Song < ActiveRecord::Base
  has_many :selections
  has_many :users, :through => :selections

  validates_presence_of :name
  validates_presence_of :artist

  after_update :recalculate_users

  def recalculate_users
    User.recalculate_scores
  end

  def name_and_artist
    "#{name} - #{artist}"
  end

  def self.scrape_songs
    require 'open-uri'
    for i in 0..26
      url = "http://www2b.abc.net.au/votecentral/Client/PlaceVote.aspx?E=96&IX=0&IG=#{i}"
      doc = Nokogiri::HTML(open(url))

      list = doc.at("div .IndexPageContent")
      list = list.at("p")

      list.css("span .artist").each do |item|
        Song.create(name:item.next_element.next_element.text.strip, artist: item.text.strip )
      end
    end
  end
end
