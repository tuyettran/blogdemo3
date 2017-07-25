class PostsController < ApplicationController
  before_action :load_post, except: :create
  load_and_authorize_resource

  def create
    @comment = Comment.new
    @post = current_user.posts.build post_params

    if @post.save
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
    if @post.update_attributes post_params
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

  private

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post
    render file: "public/404"
  end

  def post_respond
    respond_to do |format|
      format.html{redirect_to request.referrer || root_url}
      format.js
    end
  end

  def post_js message, status
    @status = status
    @message = message
    respond_to do |format|
      format.js
    end
  end
end
