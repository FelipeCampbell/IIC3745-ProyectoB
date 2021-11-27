Rails.application.routes.draw do
  resources :movies
  get 'seats/movie_id=:movie_id&room=:room_id&time=:time_id', to: "seats#index", as: :buy_seats
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
