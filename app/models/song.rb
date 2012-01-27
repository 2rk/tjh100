class Song < ActiveRecord::Base
  has_many :selections
  validates_presence_of :name
  validates_presence_of :artist
end
