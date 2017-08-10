class PostsManagerController < ApplicationController
  before_action :verify_admin
  before_action :load_post, only: [:update, :destroy]
  before_action :post_search, only: :search

  def index
    @posts = Post.all.page(params[:page]).per Settings.post.per_page
    @post = Post.new
    @users = User.all.order_asc_name
  end

  def create
    @post = Post.new post_params
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

  def destroy
    if @post.destroy
      post_massage 200
    end
    post_respond
  end

  def search
    @posts = @result.page(params[:page]).per Settings.post.per_page
    @post = Post.new
    @users = User.all.order_asc_name
    respond_to do |format|
      format.html{render :index}
      format.csv{send_data Post.to_csv(@result)}
      format.js
    end
  end

  def bulk_destroy
    @post_ids = params[:post_ids]
    if Post.destroy @post_ids
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
    params.require(:post).permit :title, :content, :user_id, :post_ids
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post
    render file: "public/404"
  end

  def post_search
    @post_key = "%#{params[:post_key]}%"
    @user_key = "%#{params[:user_key]}%"
    @result = Post.advanced_search @post_key, @user_key
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
