# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :selection do
    user
    song
    number_one false
  end
end
