PocApiApp::Application.routes.draw do
  resources :users
  resources :tasks, except: :edit
end
