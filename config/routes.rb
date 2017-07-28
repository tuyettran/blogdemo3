Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  root "static_pages#home"
  devise_for :users, controllers: {registrations: "registrations"}

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
  get "/feed", to: "users#feed"
  post "search", to: "search#index"
  post "search-user", to: "search#search_user"
end
