Rails.application.routes.draw do
  root 'rentals#hub'
  resources :rentals, only: [:new, :create, :show] do

    collection do
      get 'hub'
      get 'retreive'
      put 'complete'
    end
  end

  namespace :admin do
    resources :lockers, only: [:index, :show] do
      member do
        post 'retreive'
      end
    end
  end
end
