module ResourceComment
  extend ActiveSupport::Concern

  included do
    before_action :load_comment, except: :create
  end

  private

  def comment_params
    params.require(:comment).permit :post_id, :content
  end

  def load_comment
    @comment = Comment.find_by id: params[:id]
    return if @comment
    render file: "public/404"
  end

  def comment_respond
    respond_to do |format|
      format.html{redirect_to request.referrer || root_url}
      format.js
    end
  end

  def comment_js message, status
    @status = status
    @message = message
    respond_to do |format|
      format.js
    end
  end
end
