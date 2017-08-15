class Post < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper
  attr_accessor :tag_list

  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy

  paginates_per Settings.post.per_page

  scope :order_desc, ->{order created_at: :desc}
  scope :select_order_desc, ->{select("id", "title", "content", "user_id").order_desc}
  scope :enable, ->{where "enabled = ?", true}

  scope :feed_by_following, lambda{|following_ids|
    where("user_id IN (?)", following_ids).enable.order_desc
  }

  scope :search, lambda{|keyword|
    where("title LIKE :keyword
      OR content LIKE :keyword", keyword: keyword)
  }

  scope :advanced_search, lambda{|post_key, user_key|
    if user_key.blank?
      select_order_desc.where("title LIKE :post_key", post_key: post_key)
    elsif post_key.blank?
      select_order_desc.joins(:user).where("users.full_name LIKE :user_key",
      user_key: user_key)
    else
      select_order_desc.joins(:user).where("users.full_name LIKE :user_key AND
        posts.title LIKE :post_key", post_key: post_key, user_key: user_key)
    end
  }

  scope :months_before, lambda{|current_time|
    where("created_at < ? AND created_at > ?", current_time, current_time-60*60*24*30)
  }

  validates :user, presence: true
  validates :title, presence: true,
    length: {maximum: Settings.post.title.max_length}
  validates :content, presence: true,
    length: {maximum: Settings.post.content.max_length}
  validates :tag_list, presence: true, allow_blank: true
  validate :content_not_blank

  def tags_name
    return {} unless tags.present?
    Tag.joins(:post_tags).where("post_tags.post_id = #{id}").pluck :name
  end

  def create_post_tags
    ActiveRecord::Base.transaction do
      self.save!
      if validate_number_tags && build_tags
        return true
      else
        raise ActiveRecord::Rollback
      end
    end
    rescue ActiveRecord::RecordInvalid
    return false
  end

  def update_post_tags post_params
    ActiveRecord::Base.transaction do
      update_attributes post_params
      if validate_number_tags && update_tags
        return true
      else
        raise ActiveRecord::Rollback
      end
    end
    rescue ActiveRecord::RecordInvalid
    return false
  end

  def validate_number_tags
    max_tags = Settings.post.max_tags

    if tag_list.present?
      list = tag_list.split(",")
      list.uniq!
      if list.length > max_tags
        errors.add :tag_list, I18n.t("tags.too_much_tag")
        return false
      end
    end
    true
  end

  def update_tags
    tags.delete_all
    build_tags
  end

  def build_tags
    return true unless tag_list.present?

    tag_list.split(",").each do |tag|
      tags << Tag.find_or_create_by!(name: tag.strip)
    end
    rescue ActiveRecord::RecordInvalid => exception
    errors[:tag_list] << exception.message
    return false
  end

  def content_not_blank
    errors.add :content, I18n.t("posts.content_not_blank") if strip_tags(content).blank?
  end

  class << self
    def to_csv posts
      column_names = %w{id title content}
      CSV.generate do |csv|
        csv << column_names
        posts.each do |post|
          csv << post.attributes.values_at(*column_names)
        end
      end
    end

    def bulk_destroy ids
      where(id: ids).destroy_all
    end
  end
end
