module ResourcePost
  extend ActiveSupport::Concern

  included do
    before_action :load_post, except: :create
  end

  private

  def post_params
    params.require(:post).permit :title, :content, :tag_list
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post.try :enabled == true
    render file: "public/404"
  end

  def post_js message, status
    @status = status
    @message = message
    respond_to do |format|
      format.js
    end
  end

  def post_respond
    respond_to do |format|
      format.html{redirect_to request.referrer || root_url}
      format.js
    end
  end
end
