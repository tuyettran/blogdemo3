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

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
    omniauth_providers: [:facebook, :google_oauth2]

  before_save :downcase_email

  scope :search, lambda{|keyword|
    where "full_name LIKE :keyword OR email LIKE :keyword
      OR phone_number LIKE :keyword", keyword: keyword
  }

  scope :hot_user, lambda{
    joins(:followers).group("users.id").order("count(users.id) DESC")
      .limit Settings.user.hot_user.limit
  }
  scope :months_before, lambda{|current_time|
    where("created_at < ? AND created_at > ?", current_time, current_time-60*60*24*30)
  }

  validates :full_name, presence: true,
    length: {maximum: Settings.user.full_name.max_length}
  validates :phone_number, format: {with: VALID_PHONE_REGEX},
    length: {maximum: Settings.user.phone_number.max_length}
  validates_presence_of :uid
  validates_uniqueness_of :uid
  validate :avatar_size

  def self.from_facebook auth
    User.find_or_initialize_by(email: auth.info.email).tap do |user|
      user.full_name = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = User.generate_unique_secure_token if user.new_record?
      user.save
    end
  end

  def self.from_google auth
    User.find_or_initialize_by(email: auth.info.email).tap do |user|
      user.full_name = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = User.generate_unique_secure_token if user.new_record?
      user.save
    end
  end

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
