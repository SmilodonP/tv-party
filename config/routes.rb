Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :movies do
        resources :search, only: [:index]
      end
      resources :users, only: [:create, :index, :show]
      resources :sessions, only: :create
      resources :viewing_parties, only: [:create] do
        post 'invitees', to: 'viewing_parties#add_invitee'
      end
      resources :movies, only: [:index, :show]
    end
  end
end
