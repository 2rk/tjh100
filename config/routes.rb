Tjh100::Application.routes.draw do

  resources :tweets

  devise_for :users

  resources :songs do
    resources :selections, :only => :create
    resources :users, :only => :index
  end

  resources :users do
    member { get 'lock' }
    resources :selections, :only => :index
  end

  resources :selections, :only => [:destroy, :update, :index]

  root :to => "songs#index"

end
