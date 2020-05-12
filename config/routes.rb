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

  # 既読管理 member:idを渡す（/activities/:id/read）
  # path:更新する
  # only: [] do：不要なルーティングを作成しないように
  resources :activities, only: [] do
    patch :read, on: :member
  end

  namespace :mypage do
    # プロフィール編集
    resource :account, only: %i[edit update]
    # 通知
    resources :activities, only: %i[index]
  end
end
