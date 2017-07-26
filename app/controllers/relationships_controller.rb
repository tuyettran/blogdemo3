class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find_by id: params[:followed_id]
    render file: "public/404" unless @user

    if current_user.follow @user
      relationships_js t(".success"), 200
    else
      relationships_respond
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    render file: "public/404" unless @user

    if current_user.unfollow @user
      relationships_js t("success"), 200
    else
      relationships_respond
    end
  end

  private

  def relationships_respond
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def relationships_js message, status
    @status = status
    @message = message
    respond_to do |format|
      format.js
    end
  end
end
