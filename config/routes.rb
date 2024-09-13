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
    resources :users, only: %i[index show update] do
      collection do
        get :age_distribution # 年齢分布のデータを取得
        get 'inactive' # 非アクティブユーザー表示用のルートを追加
      end
    end
    resources :posts, only: %i[index show destroy] do
      resources :post_comments, only: %i[destroy]
    end
    get "/" => "homes#top"
  end

  # Public側のルーティング
  scope module: :public do
    root to: 'homes#top'
    get 'about', to: 'homes#about'
    resources :users, except: %i[new create] do
      collection do
        get 'mypage', to: 'users#mypage'
        patch 'withdraw'  # 退会処理
      end

      member do
        get '/likes' => 'users#likes'
      end

      resources :relationships, only: %i[create destroy]
        get "followings" => "relationships#followings", as: "followings"
        get "followers" => "relationships#followers", as: "followers"
    end

    resources :posts do
      resource :favorite, only: %i[create destroy]
      resources :post_comments, only: %i[create destroy]
    end
  end
end