FactoryGirl.define do
  factory :tweet do
    sequence(:status) {|n| "##{101-n} @band_#{101-n} - 'song_name_#{101-n}'"}
    sequence(:position) {|n| 101-n}
    song
  end
end
