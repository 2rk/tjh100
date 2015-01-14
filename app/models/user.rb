class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates :name, presence: true

  has_many :selections, dependent: :destroy
  has_many :songs, :through => :selections
  has_many :guests

  def max_selections
    selections.count >= Selection::SELECTION_QTY
  end

  def self.recalculate_scores
    User.all.each do |user|
      user.calculate_score
    end
    if Song.find_by_position(1)
      calculate_number1
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
    selections.count == Selection::SELECTION_QTY && number1_selected?
  end

  def number1_selected?
    selections.where(:number_one => true).count !=0
  end

  def self.number_submitted
    User.where(locked: true).count
  end

  def display_name_and_submitted
    if locked?
      name + " (submitted)"
    else
      name
    end
  end

  def self.calculate_number1

    top_hit = Selection.joins(:song).where(number_one: true).order(:position).first

    Selection.where(number_one: true, song_id: top_hit.song_id).each do |selection|
      p selection.user
      selection.user.update_attribute(:score, selection.user.score + Selection::NUMBER1_BONUS )
    end




    #for i in 1..100
    #  song = Song.find_by_position(i)
    #  selections = Selection.where(:song_id => song, :number_one => true)
    #  #p song
    #  #p selections
    #  if selections
    #    selections.each do |selection|
    #      #p selection
    #      selection.user.score += Selection::NUMBER1_BONUS
    #    end
    #    break
    #  end
    #end
  end

end
