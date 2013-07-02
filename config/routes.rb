PocApiApp::Application.routes.draw do
  devise_for :users, :controllers => {registrations: 'registrations'}, defaults: { format: 'json' }
  resources :users
  resources :tasks, except: :edit
  resources :tokens, only: [:create, :destroy, :show], :defaults => { :format => 'json' }
  match 'tokens', :via => :options, :action => :create, :controller => 'tokens', defaults: { format: 'json' }
end
