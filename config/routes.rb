Tjh100::Application.routes.draw do

  devise_for :users

  resources :songs do
    resources :selections, :only => :create
  end

  resources :users do
    resources :selections, :only => :index
  end

  resources :selections, :only => [:destroy, :update]

  root :to => "songs#index"

end
