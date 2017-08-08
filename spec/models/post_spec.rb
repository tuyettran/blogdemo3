require "rails_helper"

RSpec.describe Post, type: :model do
  context "associations" do
    it do
      is_expected.to belong_to :user
      is_expected.to have_many :post_tags
      is_expected.to have_many :comments
    end
  end
end
