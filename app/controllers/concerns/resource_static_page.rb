module ResourceStaticPage
  extend ActiveSupport::Concern

  private

  def feed_items
    @feed_items = Post.enable.order_desc
                  .page(params[:page]).per Settings.post.per_page
  end

  def hot_users
    @hot_user = User.hot_user
  end

  def popular_tags
    @popular_tag = Tag.popular
  end

end
