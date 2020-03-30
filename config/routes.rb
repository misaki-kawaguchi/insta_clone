Rails.application.routes.draw do
  root 'users#new'

  #ユーザー登録
  resources :users, only: %i[new create]
  #ログイン、ログアウト
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
