Rails.application.routes.draw do
  root 'posts#index'

  # ログイン、ログアウト
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  # ユーザー登録
  resources :users, only: %i[index new create show]

  # 投稿
  resources :posts, shallow: true do
    # 検索(collectionを使うとposts/searchのようにpost_id無しのルーティングとなる)
    collection do
      get :search
    end
    # コメント
    resources :comments, shallow: true
  end

  # いいね機能
  resources :likes, only: %i[create destroy]

  # フォロー機能
  resources :relationships, only: %i[create destroy]
end
