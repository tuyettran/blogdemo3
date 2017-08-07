class SearchController < ApplicationController
  def search_post
    keyword = "%#{params[:keyword]}%"
    @feed_items = Post.search(keyword).page(params[:page])
            .per Settings.post.per_page
    render "post_search_result"
  end

  def search_user
    keyword = "%#{params[:keyword]}%"
    @users = User.search(keyword).page(params[:page])
            .per Settings.user.per_page
    render "user_search_result"
  end
end
