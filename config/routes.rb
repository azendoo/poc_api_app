PocApiApp::Application.routes.draw do
  apipie

  devise_for :users, controllers: { sessions: "tokens" },
    skip: [:sessions, :registrations, :confirmation, :password],
    defaults: { format: 'json' }

  api vendor_string: 'azendoo', default_version: 1, path: nil do
    version 1 do
      cache as: 'v1' do

        root to: "home#index"

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

    version 2 do
      inherit from: 'v1'
    end

  end

end
