Rails.application.routes.draw do


  api_version(:module => "V1", :path => {:value => "api/v1"}) do
    resources :users
    resources :videos
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
