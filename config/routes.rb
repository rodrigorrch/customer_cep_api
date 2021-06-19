Rails.application.routes.draw do
  devise_for :users

  api_version(:module => "V1", :path => {:value => "v1"}) do
    resources :addresses
  end

  root to: "home#index"
end
