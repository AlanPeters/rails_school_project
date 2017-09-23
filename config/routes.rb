Rails.application.routes.draw do
  devise_for :users
  resources :sections
  resources :courses
  resources :professors do
    collection do
      get "search"
    end 
  end
  root to: "professors#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
