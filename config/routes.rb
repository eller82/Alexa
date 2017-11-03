Rails.application.routes.draw do

  root 'alexa#index'

  get 'alexa/index'
  post 'alexa/savePVoutput'
  patch 'alexa/savePVoutput'

  #devise_for :users
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  #devise_for :users, :controllers: { registrations: 'users/registrations' }
  #devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }


  #Alexa for pvoutput.org
  namespace :pvoutput do
    namespace :v1 do
      post 'pvoutput', :to => "pvoutput#index"
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
