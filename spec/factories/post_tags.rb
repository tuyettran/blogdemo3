require "faker"
FactoryGirl.define do
  factory :post_tag do |f|
    f.post nil
    f.tag nil
  end
end
