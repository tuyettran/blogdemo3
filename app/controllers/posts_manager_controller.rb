class PostsManagerController < ApplicationController
  before_action :verify_admin
  before_action :load_post, only: :update
  before_action :post_search, only: :index

  def index
    @post = current_user.posts.build
    if params[:post_key] || params[:user_key]
      @posts = @search_result.includes(:user).page(params[:page])
              .per Settings.post.per_page

      respond_to do |format|
        format.html{render :index}
        format.csv{send_data Post.to_csv(@search_result.includes(:user))}
        format.js
      end
    else
      @posts = Post.select_order_desc.includes(:user).page(params[:page])
              .per Settings.post.per_page
    end
  end

  def create
    @post = current_user.posts.build post_params
    @posts = Post.select_order_desc.includes(:user).page(params[:page])
            .per Settings.post.per_page
    if @post.save
      post_massage 200
    end
    post_respond
  end

  def update
    if @post.update_attributes post_params
      post_massage 200
    end
    post_respond
  end

  def destroy_posts
    @post_ids = params[:post_ids]
    @posts = Post.select_order_desc.includes(:user).page(params[:page])
            .per Settings.post.per_page
    if Post.bulk_destroy @post_ids
      post_massage 200
    end
    post_respond
  end

  private

  def verify_admin
    return if current_user.try :admin?
    flash[:danger] = t "posts_manager.permission_denied"
    redirect_to root_path
  end

  def post_params
    params.require(:post).permit :title, :content, :post_ids
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post
    render file: "public/404"
  end

  def post_search
    @post_key = "%#{params[:post_key]}%"
    @user_key = "%#{params[:user_key]}%"
    @search_result = Post.advanced_search @post_key, @user_key
  end

  def post_massage status
    @status = status
  end

  def post_respond
    respond_to do |format|
      format.js
    end
  end
end
