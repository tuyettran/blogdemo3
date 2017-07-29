class User < ApplicationRecord
  VALID_PHONE_REGEX = /\A(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*\z/

  enum role: [:member, :admin]
  enum gender: [:male, :female, :other]

  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passtive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :passtive_relationships, source: :follower
  has_many :following, through: :active_relationships, source: :followed

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  before_save :downcase_email

  scope :search, lambda{|keyword|
    where "full_name LIKE :keyword OR email LIKE :keyword
      OR phone_number LIKE :keyword", keyword: keyword
  }

  scope :hot_user, lambda{
    joins(:followers).group("users.id").order("count(users.id) DESC")
      .limit Settings.user.hot_user.limit
  }

  validates :full_name, presence: true,
    length: {maximum: Settings.user.full_name.max_length}
  validates :phone_number, format: {with: VALID_PHONE_REGEX},
    length: {maximum: Settings.user.phone_number.max_length}
  validate :avatar_size

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def current_user? user
    self == user
  end

  def send_comment_notify_email comment
    UserMailer.comment_notify(comment).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def avatar_size
    errors.add :avatar, I18n.t("user.avatar.too_big_file") if
      avatar.size > Settings.user.avatar.max_size.megabytes
  end
end
