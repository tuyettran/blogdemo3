class Ability
  include CanCan::Ability

  def initialize user
    alias_action :update, :destroy, to: :modify
    if user
      user_id = user.id
      if user.try :admin?
        can :manage, :all
        can :access, :rails_admin
        can :dashboard
      end

      can :read, :all
      can :create, Post
      can [:modify], Post, user_id: user_id
      comment_permission user
    else
      cannot [:create, :modify], :all
    end
  end

  private

  def comment_permission user
    user_id = user.id
    can :create, Comment do |build_comment|
      post_author = build_comment.post.user
      user.following?(post_author) || user == post_author
    end
    can :update, Comment, user_id: user_id
    can :destroy, Comment do |comment|
      user == comment.user || user == comment.post.user
    end
  end
end
