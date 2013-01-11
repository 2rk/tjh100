# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "name_#{n}"}
    sequence(:email) {|n| "email_#{n}@example.com"}
    password "secret"
    admin false
    factory :user_admin do
      admin true
    end
  end
end
