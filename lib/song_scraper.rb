require 'capybara'
require "capybara/rspec"
require 'capybara/poltergeist'

Capybara.default_driver = :poltergeist

class SongScraper
  include Capybara::DSL
  # TODO: seank call this method from a rake task?
  # atm its an instance method, this could either be changed to a class method or use my class method instantation
  # i.e. SongScraper.scrape which creates a new instance of SongScraper and calls scrape on that instance
  # There's no tests here, *but* i'd argue its unnecessary
  def scrape
    for i in 'A'..'Z'
      url = "https://hottest100.triplej.net.au/artist/start/#{i}"
      visit url
      all(".textContainer").each do |container|
        artist = container.find(".text").text
        title = container.find(".secondary-type").text
        song =  Song.create(name: title, artist: artist)
        song
      end
    end
  end
end