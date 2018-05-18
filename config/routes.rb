Rails.application.routes.draw do
  resources :movies

  devise_for :users

  resources :movie_reactions
  post '/movies/:id/:reaction', to: 'movies#react_to_movie', as: :react_to_movie

  root 'movies#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
