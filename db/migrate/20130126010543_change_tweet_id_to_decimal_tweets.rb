class ChangeTweetIdToDecimalTweets < ActiveRecord::Migration

  def change
    change_column :tweets, :tweet_id, :bigint
  end
end
