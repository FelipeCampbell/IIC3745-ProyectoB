class SeatsController < ApplicationController

  def index 
    @movie = Movie.where(id: params[:movie_id]).first
    @room = params[:room_id]
    puts "HII"
    puts params[:admin]
    puts "---"
    @time = ["Matiné", "Tanda", "Noche"][(params[:time_id].to_i)-1]
    screening = Screening.where(movie_id: @movie.id, room: @room.to_i, time: params[:time_id].to_i).first
    @ocuppied_seats = Seat.where(screening_id: screening.id)
    if $clicked_seats
      add_or_remove_clicked_seat
    else
      $clicked_seats = []
    end
  end

  def create
    mid, room, time = params[:movie_id], params[:room_id], (["Matiné", "Tanda", "Noche"].find_index(params[:time_id])+1)
    screening = Screening.where(movie_id: mid, room: room.to_i, time: time).first
    $clicked_seats.each do |seat|
      Seat.create(col: seat[:col], row: seat[:row], screening_id: screening.id)
    end
    $clicked_seats = []
    redirect_to view_seats_path(mid, room, time)
  end

  def empty
    $clicked_seats = []
    redirect_to movies_path(admin: params[:admin])
  end

  def add_or_remove_clicked_seat
    if params[:row] and params[:col]
      clicked_seat = {row: params[:row], col: params[:col].to_i}
      if $clicked_seats.include?(clicked_seat)
        $clicked_seats.delete(clicked_seat)
      else
        $clicked_seats << clicked_seat
      end
      check_same_row_seats
    end
  end

  def check_same_row_seats
    rows = $clicked_seats.uniq{ |s| s.values_at(:row) }
    if rows.length > 1
      @message = "Recuerda solo puedes comprar asientos de la misma fila!"
    else  
      @message = ""
    end
  end

end
