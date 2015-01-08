class Party < ActiveRecord::Base
  attr_accessible :name

  has_many :guests
  has_many :users, through: :guests
end
