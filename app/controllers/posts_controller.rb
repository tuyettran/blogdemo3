class PostsController < ApplicationController
  include ResourcePost
  authorize_resource

  def create
    @comment = Comment.new
    @post = current_user.posts.build post_params
    @post.tag_list = params[:post][:tag_list]

    if @post.create_post_tags
      post_js t(".success"), 200
    else
      post_respond
    end
  end

  def show
    @comment = @post.comments.build
    @comments = @post.comments.order_asc.page params[:page]
  end

  def update
    @post.tag_list = params[:post][:tag_list]

    if @post.update_post_tags post_params
      post_js t(".success"), 200
    else
      post_respond
    end
  end

  def destroy
    if @post.destroy
      post_js t(".success"), 200
    else
      post_respond
    end
  end
end
