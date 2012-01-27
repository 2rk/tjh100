# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :song do
    sequence(:name) {|n| "song_#{n}"}
    sequence(:artist) {|n| "artist_#{n}"}
    position nil
  end
end
