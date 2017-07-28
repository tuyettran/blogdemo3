class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  scope :popular, lambda{
    joins(:post_tags).group(:id).order("count(post_id) DESC")
      .limit Settings.tag.popular.limit
  }

  validates :name, presence: true, length: {maximum: Settings.tag.max_length}
end
