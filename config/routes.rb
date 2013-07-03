PocApiApp::Application.routes.draw do

  root to: "home#index"

  devise_for :users,
    skip: [:sessions, :registrations, :password, :confirmation],
    defaults: { format: 'json' }

  resources :users, :controller => 'users', except: [:edit, :new, :create]

  devise_scope :user do
    post 'users', to: 'registrations#create'
  end

  resources :tasks, except: :edit
  resources :tokens, only: [:create, :destroy, :show], defaults: { format: 'json' }

  match 'tokens', via: :options, action: :create, controller: 'tokens', defaults: { format: 'json' }

end
