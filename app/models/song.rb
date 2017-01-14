require 'csv'

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

  def points
    101 - position if position
  end

  # TODO: seank remove the below, now housed in lib/song_scraper.rb
  def self.scrape_songs
    require 'open-uri'
    for i in 0..26
      url = "https://hottest100.triplej.net.au/artist/start/#{i}"
      doc = Nokogiri::HTML(open(url))

      list = doc.at("div .IndexPageContent")
      if list
        list = list.at("p")

        list.css("span .artist").each do |item|
          unless item.next_element.next_element.next_element.attribute('data-hash').value.blank?
            Song.create(name: item.next_element.next_element.text.strip, artist: item.text.strip)
            #p item.next_element.next_element.text.strip
            #p item.text.strip
          end
        end
      end
    end
  end

  #Change with website in 2016 has the punter having to authenticate first
  def self.import_songs
    CSV.foreach("db/tjh100_2017.csv") do |line|
      Song.create(name: line[1].strip, artist: line[0].strip)
    end
  end
end
