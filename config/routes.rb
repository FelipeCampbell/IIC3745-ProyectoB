Rails.application.routes.draw do
  resources :movies
  get 'seats/movie_id=:movie_id&room=:room_id&time=:time_id', to: 'seats#index', as: :view_seats
  post 'seats/movie_id=:movie_id&room=:room_id&time=:time_id', to: 'seats#create', as: :buy
  get 'seats/', to: 'seats#empty', as: :empty

  get 'welcome/index'
  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
