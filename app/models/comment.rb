class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true
  validates :post, presence: true
  validates :user, presence: true

  paginates_per Settings.comment.per_page

  scope :order_asc, ->{order created_at: :asc}
end
