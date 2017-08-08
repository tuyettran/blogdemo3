require "faker"
FactoryGirl.define do
  factory :user do |f|
    f.full_name Faker::Name.name
    f.email "tuyet.tran.k59@gmail.com"
    f.gender 1
    f.role 0
    f.phone_number Faker::PhoneNumber.cell_phone
    f.avatar "image.png"
    f.password "foobar"
    f.password_confirmation "foobar"
  end
end
