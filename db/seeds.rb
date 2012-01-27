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
Factory(:user, :name => "Nigel", :email => "nigel@rausch.com.au", :password => "secret")

users = FactoryGirl.create_list(:user,3)
songs = []
50.times do
  songs << Factory(:song, :name => Faker::Name.last_name)
end
Factory(:selection, :song => songs[1], :user => users[0])
Factory(:selection, :song => songs[1], :user => users[1])
Factory(:selection, :song => songs[3], :user => users[0], :number_one => true)