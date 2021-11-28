# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Movie.create(name: 'M1', image: 'https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/1200/public/media/image/2021/08/noahs-shark-2439421.jpg?itok=6IIApJbv')
Screening.create(room: 1, date: DateTime.new(2015, 6, 22), time: 1, movie_id: 1)
Seat.create(col: 1, row: "B", screening_id: 1)
Seat.create(col: 1, row: "C", screening_id: 1)
Seat.create(col: 2, row: "B", screening_id: 1)
Seat.create(col: 3, row: "B", screening_id: 1)