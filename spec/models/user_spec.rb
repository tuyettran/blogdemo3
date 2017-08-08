require "rails_helper"

RSpec.describe User, type: :model do
  context "associations" do
    it do
      is_expected.to have_many :comments
      is_expected.to have_many :posts
    end
  end
  context "validate" do
    it do
      is_expected.to validate_presence_of :email
      is_expected.to validate_presence_of :password
      is_expected.to validate_presence_of :role
      is_expected.to validate_presence_of :gender
    end
  end
end
