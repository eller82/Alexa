Rails.application.routes.draw do

  root 'alexa#index'

  get 'alexa/index'

  devise_for :users

  #Alexa for pvoutput.org
  namespace :pvoutput do
    namespace :v1 do
      post 'pvoutput', :to => "pvoutput#index"
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
