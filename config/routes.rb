Rails.application.routes.draw do
  root 'home#index'
  resources :events do
    resources :rsvps
  end
  
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
