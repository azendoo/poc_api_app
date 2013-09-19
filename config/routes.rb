PocApiApp::Application.routes.draw do

  root to: "home#index"

  # NOTE :
  # routes under your default version show up twice when running rake routes
  # This is due to the fact that Versionist adds another scope to your routes
  # to handle the default case. Unfortunately rake routes does not show you enough
  # contextual information to be able to differentiate the two, but this is the
  # expected behavior.

  # API V1 routes
  api_version(:module => "V1", :header => {:name => "Accept", :value => Mime::API_V1}, :default => true) do

    # rewrite devise behavior
    devise_for :users, controllers: { sessions: "tokens" },
      skip: [:sessions, :registrations, :confirmation, :password],
      defaults: { format: 'json' }

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

  # API V2 routes
  api_version(:module => "V2", :header => {:name => "Accept", :value => Mime::API_V2}) do

    # rewrite devise behavior
    devise_for :users, controllers: { sessions: "tokens" },
      skip: [:sessions, :registrations, :confirmation, :password],
      defaults: { format: 'json' }

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


end
