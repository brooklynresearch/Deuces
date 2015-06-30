Rails.application.routes.draw do
  root 'rentals#hub'
  resources :rentals, only: [:new, :create, :show] do

    collection do
      get 'hub'
      get 'retrieve'
      put 'complete'
    end
  end

  namespace :admin do
    resources :lockers, only: [:index, :show] do
      member do
        post 'retrieve'
      end
    end
  end
  match 'admin' => "admin/lockers#index", via: 'get'
end
