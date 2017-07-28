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
  scope :search, lambda{|keyword|
    where("title LIKE BINARY :keyword
      OR content LIKE BINARY :keyword", keyword: keyword)
  }

  validates :user, presence: true
  validates :title, presence: true,
    length: {maximum: Settings.post.title.max_length}
  validates :content, presence: true,
    length: {maximum: Settings.post.content.max_length}
  validates :tag_list, presence: true, allow_blank: true

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
end
