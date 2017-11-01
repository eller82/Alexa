Rails.application.routes.draw do

  #root 'pvoutput#index'

  get 'pvoutput/index'
  #post 'pvoutput/index'
  post "/" => "pvoutput#index", :as => "root"
  #post root

  namespace :pvoutput do
    namespace :v1 do
      post 'pvoutput', :to => "pvoutput#index"
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
