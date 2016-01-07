# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

User.delete_all
Selection.delete_all
Song.delete_all
Tweet.delete_all

Factory(:user, :name => "Nigel", :email => "nigel.rausch@tworedkites.com", :password => "secret")
Factory(:user, :name => "Sean", :email => "sean.kelly@tworedkites.com", :password => "secret", admin: true)

#Song.scrape_songs
Song.import_songs

############################################################
#  Remove the following section before running in production
############################################################

#users = FactoryGirl.create_list(:user,3)
#
# songs = []
# 50.times { songs << Factory(:song, :name => Faker::Name.last_name) }

# add random selections
#User.all.each do |user|
#  Song.all.each do |song|
#    Factory(:selection, song: song, user: user) if rand(3) == 1 && user.selections.count < Selection::SELECTION_QTY
#  end
#end

# create some tweets randomly
#pos = 100
#Song.all.each do |song|
#  if rand(3) == 1
#    Factory(:tweet, :status => "##{pos} @#{song.artist} - '#{song.name}'", :song => song)
#    pos -=1
#  end
#  break if pos == 0
#end

puts "Songs       = #{Song.count}"
puts "Selections  = #{Selection.count}"
puts "Tweets      = #{Tweet.count}"