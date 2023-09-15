Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers do 
        resources :subscriptions, only: %i[index create]
        delete '/subscriptions/:id', to: 'subscriptions#cancel'
      end
    end
  end
end
