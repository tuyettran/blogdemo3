require "faker"
FactoryGirl.define do
  factory :post do |f|
    f.title "title"
    f.content "content"
    f.user nil
  end
end
