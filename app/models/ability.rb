class Ability
  include CanCan::Ability

  def initialize user
    if user
      user_id = user.id
      can :manage, :all if user.try :admin?
      can :read, :all
      can :create, Post
      can [:update, :destroy], Post, user_id: user_id
    else
      cannot [:create, :update, :destroy], :all
    end
  end
end
