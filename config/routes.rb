PocApiApp::Application.routes.draw do
  apipie
  root to: "home#index"

  devise_for :users, controllers: { sessions: "tokens" }, skip: [:sessions, :registrations, :confirmation], defaults: { format: 'json' }
  resources :users, controller: 'users', except: [:edit, :new, :create] do
    get 'me', :on => :collection, defaults: { format: 'json' }
  end

  devise_scope :user do
    post 'users', to: 'registrations#create'
    post 'login', to: 'tokens#create'
    delete 'logout', to: 'tokens#destroy'
  end

  resources :tasks, except: [:edit, :new]

end
