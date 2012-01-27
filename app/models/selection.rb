class Selection < ActiveRecord::Base
  SELECTION_QTY = 10
  belongs_to :user
  belongs_to :song
end
