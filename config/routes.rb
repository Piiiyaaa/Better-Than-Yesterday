Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :posts, only: %i[index new create show edit update destroy] do
    resource :like, only: [ :create, :destroy ]
  end

  resources :relationships, only: [ :create ]
  delete "relationships", to: "relationships#destroy"

  resources :daily_questions, only: [ :index, :show ] do
    resources :answers, only: [ :create ]
  end

  resource :profile, only: %i[show edit update], controller: "profiles"
  get "profiles/:id", to: "profiles#show", as: "user_profile"
  get "profiles/:id/followings", to: "profiles/followings#index", as: "user_profile_followings"
  get "profiles/:id/followers", to: "profiles/followers#index", as: "user_profile_followers"

  resources :profiles, only: [ :show ] do
    member do
      get :followings, to: "profiles/followings#index"
      get :followers, to: "profiles/followers#index"
    end
  end
  post "ai_generate_question", to: "ai#generate_question"

  resources :contacts, only: [ :new, :create ] do
    collection do
      post "confirm"
      post "back"
      get "done"
    end
  end

  root "home#top"

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
