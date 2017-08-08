require "rails_helper"

RSpec.describe Tag, type: :model do
  context "associations" do
    it{is_expected.to have_many :post_tags}
  end

  context "validates" do
    it{is_expected.to validate_presence_of :name}
  end
end
