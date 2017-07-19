require "rails_helper"

RSpec.describe Comment, type: :model do
  context "associations" do
    it do
      is_expected.to belong_to :user
      is_expected.to belong_to :post
    end
  end
end
