Rails.application.routes.draw do
  root "static_pages#home"
  get "signup", to: "users#new"
  resources :users, only: [:create]
  resources :tags, except: [:show]
  resources :words

  get    'login',  to: 'sessions#new'     # ログイン画面を見せる
  post   'login',  to: 'sessions#create'  # ログイン実行（データ処理）
  delete 'logout', to: 'sessions#destroy' # ログアウト実行
end
