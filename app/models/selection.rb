class Selection < ActiveRecord::Base
  SELECTION_QTY = 40
  belongs_to :user
  belongs_to :song

  before_update :toggle_number_one

  private

  def toggle_number_one
    user.selections.where(:number_one => true).where("id != #{self.id}").update_all(:number_one => false)
  end
end
