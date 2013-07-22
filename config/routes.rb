PocApiApp::Application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: { sessions: "tokens" }, skip: [:sessions, :registrations, :confirmation], defaults: { format: 'json' }
  resources :users, controller: 'users', except: [:edit, :new, :create]

  devise_scope :user do
    post 'users', to: 'registrations#create'
    post 'login', to: 'tokens#create'
    delete 'logout', to: 'tokens#destroy'
  end

  resources :tasks, except: [:edit, :new]

  # custom routes for json responses :
  match '/404', to: 'errors#not_found'
  match '/422', to: 'errors#unprocessable'
  match '/500', to: 'errors#internal_server'
end
