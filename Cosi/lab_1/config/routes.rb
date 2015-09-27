Rails.application.routes.draw do
  resources :distributions, only: [:new, :create, :edit, :update]

  root 'distributions#main_page'
end