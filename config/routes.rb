Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  mount Ckeditor::Engine => "/ckeditor"
  root "static_pages#home"
  devise_for :users, controllers: {registrations: "registrations",
    omniauth_callbacks: "omniauth_callbacks"}

  resources :users, only: [:show] do
    member do
      get :following, :followers
    end
  end

  resources :posts, except: [:new, :edit, :index] do
    resources :comments, except: [:index, :new, :show]
  end

  resources :relationships, only: [:create, :destroy]
  resources :tags, only: :show
  resources :posts_manager, only: [:index, :create, :update] do
    collection do
      delete :destroy_posts
    end
  end
  get "/feed", to: "users#feed"
  post "search-post", to: "search#search_post"
  post "search-user", to: "search#search_user"
end
