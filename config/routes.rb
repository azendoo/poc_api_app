PocApiApp::Application.routes.draw do
  devise_for :users, :controllers => {:sessions => "sessions"}
  devise_scope :user do
    post 'sessions' => 'sessions#create', :as => 'login'
    delete 'sessions' => 'sessions#destroy', :as => 'logout'
  end
end
