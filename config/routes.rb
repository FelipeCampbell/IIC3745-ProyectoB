Rails.application.routes.draw do
  resources :movies
<<<<<<< HEAD
  get 'seats/movie_id=:movie_id&room=:room_id&time=:time_id', to: "seats#index", as: :view_seats
  post 'seats/movie_id=:movie_id&room=:room_id&time=:time_id', to: "seats#create", as: :buy

=======
  get 'welcome/index'
  root 'welcome#index'
>>>>>>> 0f2a1b5885e8a60571de0ee0f796e103b47a3080
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
