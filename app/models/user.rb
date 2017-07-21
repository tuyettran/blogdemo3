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
  has_many :followes, through: :passtive_relationships
  has_many :following, through: :active_relationships

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  before_save :downcase_email

  validates :full_name, presence: true,
    length: {maximum: Settings.user.full_name.max_length}
  validates :phone_number, format: {with: VALID_PHONE_REGEX},
    length: {maximum: Settings.user.phone_number.max_length}
  validate :avatar_size

  private

  def downcase_email
    email.downcase!
  end

  def avatar_size
    errors.add :avatar, I18n.t("user.avatar.too_big_file") if
      avatar.size > Settings.user.avatar.max_size.megabytes
  end
end
