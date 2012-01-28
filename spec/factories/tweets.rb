# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tweet do
    status "MyString"
    position 1
    song nil
  end
end
