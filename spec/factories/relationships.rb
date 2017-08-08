require "faker"
FactoryGirl.define do
  factory :relationship do |f|
    f.followed_id 1
    f.lollower_id 1
  end
end
