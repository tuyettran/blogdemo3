class UsersController < ApplicationController
  before_action :load_user, except: :feed

  def show
    @post = Post.new
    @feed_items = @user.posts.enable.order_desc
                  .page(params[:page]).per Settings.post.per_page
  end

  def feed
    if current_user.following_ids.blank?
      @feed_items = Post.feed_by_following(current_user.following.ids)
                  .page(params[:page]).per Settings.post.per_page
    end
    render "feed"
  end

  def following
    @users = @user.following.page params[:page]
    render "show_follow"
  end

  def followers
    @users = @user.followers.page params[:page]
    render "show_follow"
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    render file: "public/404"
  end
end
