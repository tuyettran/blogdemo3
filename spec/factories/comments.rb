require "faker"
FactoryGirl.define do
  factory :comment do |f|
    f.user nil
    f.post nil
    f.content "content"
  end
end
