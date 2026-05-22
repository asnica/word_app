Rails.application.routes.draw do
  get "rankings/index"
  get "quizzes/index"
  get "quizzes/show"
  root "static_pages#home"

  get "signup", to: "users#new"
  resources :users, only: [:create]

  get    'login',  to: 'sessions#new'     # ログイン画面を見せる
  post   'login',  to: 'sessions#create'  # ログイン実行（データ処理）
  delete 'logout', to: 'sessions#destroy' # ログアウト実行

  resources :words

  resources :tags, except: [:show] do
    collection do
      patch :create_tags
    end
  end

  resources :quizzes, only: [:index, :show, :create] do
    member do
      post :restart
      post :answer
      post :previous
      get :review
      get :result
    end
  end

  resources :rankings, only: [:index]

  get 'dashboard', to: 'quizzes#index'
end
