class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :status
      t.integer :position
      t.references :song
      t.integer :tweet_id

      t.timestamps
    end
    add_index :tweets, :song_id
  end
end
