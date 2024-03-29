Rails.application.routes.draw do

  root 'rentals#hub', :device_id => "0"

  scope ":device_id" do
    resources :rentals, only: [:new, :create, :show] do
      collection do
        get 'hub'
        get 'size'
        get 'retrieve'
        put 'complete'
      end
    end

    namespace :admin do
      resources :lockers, only: [:index, :show] do
        member do
          post 'clear'
          post 'disable'
        end
      end
      resources :rentals, only: [:show] do
        member do
          post 'retrieve'
          get 'confirm'
        end
        collection do
          get 'search'
          get 'results'
          post 'find'
        end
      end
    end
    match 'admin' => "admin/lockers#index", via: 'get'
  end


  resource :testing, only: [] do
    post 'good'
    post 'bad'
  end
end
