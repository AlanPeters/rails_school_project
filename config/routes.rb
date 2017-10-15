Rails.application.routes.draw do
  resources :students do
    resources :enrollments, only: [:index, :new, :create]
  end

  resources :enrollments, only: [:show, :edit, :update, :destroy]


  devise_for :users
  resources :sections do 
    collection do 
      get "search"
    end
  end

  resources :courses do 
    collection do 
      get "search"
    end
  end

  resources :professors do
    collection do
      get "search"
    end 
  end
  root to: "professors#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
