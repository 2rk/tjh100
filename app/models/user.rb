class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates :name, presence: true

  has_many :selections
  has_many :songs, :through => :selections

  def max_selections
    selections.count >= Selection::SELECTION_QTY
  end

  def self.recalculate_scores
    User.all.each do |user|
      user.calculate_score
    end
  end

  def calculate_score
    total = songs.inject(0) do |score, song|
      score += (101 - song.position) if song.position
      score
    end
    self.update_attribute(:score, total)
  end

  def display_picks
    admin? || locked?
  end

  def ok_to_submit?
    selections.count == Selection::SELECTION_QTY
  end
end
