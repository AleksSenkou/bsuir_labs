Rails.application.routes.draw do
  resources :distributions, only: [:new, :create, :edit, :update]

  # match '/main', to: 'pages#main', via: 'get'

  root 'pages#main'
end