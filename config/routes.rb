Rails.application.routes.draw do
  resources :products
  devise_for :users
  root 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :charges, only: [:new, :create]

  get 'charges/success', to: 'charges#success'
  get 'charges/cancel', to: 'charges#cancel'
end
