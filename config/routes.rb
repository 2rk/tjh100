Tjh100::Application.routes.draw do

  devise_for :users

  resources :selections
  resources :songs
  resources :users
  root :to => "users#show"

end
