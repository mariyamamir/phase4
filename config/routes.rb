Rails.application.routes.draw do
  resources :users
  resources :store_flavors
  resources :flavors
  resources :shift_jobs
  resources :jobs
  resources :shifts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
resources :employees
resources :assignments
resources :stores
# resources :demos, only: [:new, :create, :destroy]
# get 'demos/new', to: 'demos#new', as: :login
# get 'demos/destroy', to: 'demos#destroy', as: :logout

# root 'demos#new'
root to: 'employees#home', as: :home
end