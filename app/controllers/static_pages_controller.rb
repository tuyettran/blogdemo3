class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @post = current_user.posts.build
      @feed_items = Post.all.order_desc.page params[:page]
      @comment = current_user.comments.build
    end
  end
end
