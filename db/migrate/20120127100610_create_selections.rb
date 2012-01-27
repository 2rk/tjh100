class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.references :user
      t.references :song
      t.boolean :number_one

      t.timestamps
    end
    add_index :selections, :user_id
    add_index :selections, :song_id
  end
end
