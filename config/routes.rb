Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    api_version(:module => "V1", :path => {:value => "v1"}) do
      resources :addresses
    end
  end

  root to: "home#index"
end
