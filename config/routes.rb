Rails.application.routes.draw do
  get "likes/create"
  get "likes/destroy"
  get "profiles/show"
  get "profiles/edit"
  get "profiles/update"
  get "daily_questions/show"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :posts, only: %i[index new create show edit update destroy] do
    resource :like, only: [ :create, :destroy ]
  end
  
  resources :daily_questions, only: [:index, :show] do
    resources :answers, only: [:create]
  end

  resource :profile, only: [ :show, :edit, :update ]
  # 他のユーザーのプロフィール
  resources :profiles, only: [ :show ]
  post 'ai_generate_question', to: 'ai#generate_question'

  resources :contacts, only: [:new, :create] do
    collection do
      post 'confirm'
      post 'back'
      get 'done'
    end
  end

  get "homes/top"
  root "home#top"

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
