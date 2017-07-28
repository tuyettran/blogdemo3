class TagsController < ApplicationController
  before_action :load_tags

  def show
    @posts = @tag.posts.order_desc.page(params[:page]).per Settings.tag.per_page
  end

  private

  def load_tags
    @tag = Tag.find_by id: params[:id]
    return if @tag
    render file: "public/404"
  end
end
