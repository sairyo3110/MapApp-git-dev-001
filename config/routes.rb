Rails.application.routes.draw do

  get 'search', to: 'maps#search'
  get 'route', to: 'maps#route'

  get 'posts/edit'
  get 'posts/index'

  resources :maps do
    collection do
      post :update_maps
    end
  end

  get '/maps/:id/content', to: 'maps#content', as: 'map_content'
  get '/maps/:id/popup', to: 'maps#popup', as: 'map_popup'
  get 'maps/index' 
  root to: 'maps#index'
  resources :maps, only: [:index]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
