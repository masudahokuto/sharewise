Rails.application.routes.draw do

  # 顧客用
  # URL /customers/sign_in ...
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }


  # Admin側のルーティング
  namespace :admin do
    resources :users, only: %i[index show update]
    resources :posts, only: %i[index show destroy]
    get "/" => "homes#top"
    get '/about', to:'homes#about', as:'about'
  end

  # Public側のルーティング
  scope module: :public do
    root to: 'homes#top'
    get 'homes/about'
    resources :users, except: %i[new create] do
      collection do
        get 'mypage', to: 'users#mypage'
        patch 'withdraw'  # 退会処理
      end
    end

     resources :posts
  end
end