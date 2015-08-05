Rails.application.routes.draw do

  root 'rentals#hub', :device_id => "1"

  scope ":device_id" do
    resources :rentals, only: [:new, :create, :show] do
      collection do
        get 'hub'
        get 'retrieve'
        put 'complete'
      end
    end

    namespace :admin do
      resources :lockers, only: [:index, :show]
      resources :rentals, only: [:show] do
        member do
          post 'retrieve'
        end
        collection do
          get 'search'
          post 'find'
        end
      end
    end
    match 'admin' => "admin/lockers#index", via: 'get'
  end
end
