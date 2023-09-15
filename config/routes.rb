Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :customers do 
        resources :subscriptions, only: %i[index]
        delete '/subscriptions/:id', to: 'subscriptions#cancel'
      end
      post '/customers/:customer_id/teas/:tea_id', to: 'subscriptions#create'
    end
  end
end
