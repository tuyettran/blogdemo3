class CommentsController < ApplicationController
  include ResourceComment
  load_and_authorize_resource

  def create
    @comment = current_user.comments.build comment_params

    if @comment.save
      @post = @comment.post
      comment_js t("success"), 200

      @post.user.send_comment_notify_email(@comment) unless
        current_user == @post.user
    else
      comment_respond
    end
  end

  def edit
    comment_respond
  end

  def update
    if @comment.update_attributes comment_params
      comment_js t(".success"), 200
    else
      comment_respond
    end
  end

  def destroy
    @post = @comment.post
    if @comment.destroy
      comment_js t(".success"), 200
    else
      comment_respond
    end
  end
end
