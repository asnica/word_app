Rails.application.routes.draw do
  root "static_pages#home"

  get "signup", to: "users#new"
  resources :users, only: [:create]

  resources :words

  resources :tags, except: [:show] do
    collection do
      patch :update_tags
    end
  end

  get    'login',  to: 'sessions#new'     # ログイン画面を見せる
  post   'login',  to: 'sessions#create'  # ログイン実行（データ処理）
  delete 'logout', to: 'sessions#destroy' # ログアウト実行
end
