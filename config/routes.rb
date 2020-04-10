Rails.application.routes.draw do
  root 'posts#index'

  # ログイン、ログアウト
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  # ユーザー登録
  resources :users, only: %i[new create]

  # 投稿
  resources :posts do
    # コメント
    resources :comments, shallow: true
  end
end
