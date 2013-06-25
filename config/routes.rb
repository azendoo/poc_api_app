PocApiApp::Application.routes.draw do
  # Temporary routes.
  # note : I tried to avoid devise default (and useless) routes as much as possible.
  devise_for :users, :skip => [:sessions, :registrations, :password, :confirmation]
  resources :users, :controller => 'users', except: [:edit, :new]
  resources :tasks, except: :edit

  devise_scope :user do
    post '/users/sign_in', :to => 'sessions#create', :as => :user_sign_in
    delete '/users/sign_out', :to => 'session#destroy', :as => :user_sign_out
    post '/users/new', :to => 'registrations#create', :as => :user_sign_up
  end

end
