class Song < ActiveRecord::Base
  has_many :selections
  has_many :users, :through => :selections

  validates_presence_of :name
  validates_presence_of :artist

  after_update :recalculate_users

  def recalculate_users
    User.recalculate_scores
  end
end
