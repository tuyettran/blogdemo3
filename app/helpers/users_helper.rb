module UsersHelper
  def number_posts user
    return user.posts.size if user.posts.any?
  end

  def number_following user
    user.following.size
  end

  def number_followers user
    user.followers.size
  end

  def active_relationship
    @follower = current_user.active_relationships.build
  end

  def passtive_relationship other_user
    @unfollow = current_user.active_relationships
                .find_by followed_id: other_user
  end
end
