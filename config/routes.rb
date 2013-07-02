PocApiApp::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations'},
                                    skip: [:sessions, :registrations, :password, :confirmation],
                                    defaults: { format: 'json' }

  devise_scope :user do
    post 'users', to: 'registrations#create'
    get 'users', to: 'users#index'
    get '/users/:id', to: 'users#show', as: 'user'
    put '/users/:id', to: 'users#update'
    delete '/users/:id', to:'users#destroy'
  end

  resources :tasks, except: :edit
  resources :tokens, only: [:create, :destroy, :show], defaults: { format: 'json' }

  match 'tokens', via: :options, action: :create, controller: 'tokens', defaults: { format: 'json' }

end
