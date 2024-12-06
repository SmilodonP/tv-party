Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index, :show]
      resources :sessions, only: :create
      resources :viewing_parties, only: :create
      resources :movies, only: [:index, :show]
      namespace :movies do
        resources :search, only: [:index, :update]
      end
    end
  end
end
