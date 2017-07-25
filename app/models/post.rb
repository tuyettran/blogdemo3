class Post < ApplicationRecord
  attr_accessor :tag_list

  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy

  paginates_per Settings.post.per_page

  scope :order_desc, ->{order created_at: :desc}
  scope :feed_by_following, lambda{|following_ids|
    where("user_id IN (?)", following_ids).order_desc if following_ids.present?
  }

  validates :user, presence: true
  validates :title, presence: true,
    length: {maximum: Settings.post.title.max_length}
  validates :content, presence: true,
    length: {maximum: Settings.post.content.max_length}
  validates :tag_list, presence: true, allow_blank: true
end
