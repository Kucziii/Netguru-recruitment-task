Rails.application.routes.draw do
  devise_for :users

  root "home#welcome"
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :movies, only: [:index, :show] do
    member do
      get :send_info
    end
    collection do
      get :export
    end
  end

  get '/api/v1/movies' => 'api/v1/movies#index'
  get '/api/v1/movies/:id' => 'api/v1/movies#show'
  get '/api/v1/dev_data' => 'api/v1/movies#data_for_devs'
end
