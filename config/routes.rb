Tjh100::Application.routes.draw do

  devise_for :users

  resources :songs do
    resources :selections
  end

  resources :users do
    resources :selections
  end

  root :to => "users#show"

end
