class StaticPagesController < ApplicationController
  include ResourceStaticPage

  def home
    @post = Post.new
    @comment = Comment.new
    feed_items
    hot_users
    popular_tags
  end
end
