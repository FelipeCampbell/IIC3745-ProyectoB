class SeatsController < ApplicationController

  def index 
    @movie = Movie.where(id: params[:movie_id]).first
    @room = params[:room_id]
    @time = ["Matiné", "Tanda", "Noche"][(params[:time_id].to_i)-1]
    @screenings_dates = Screening.where(movie_id: @movie.id, room: @room.to_i, time: params[:time_id].to_i).select(:date).map(&:date)
    if params[:date]
      screening = Screening.where(movie_id: @movie.id, room: @room.to_i, time: params[:time_id].to_i, date: params[:date].to_date).first
      if screening
        @ocuppied_seats = Seat.where(screening_id: screening.id)
      end
    else
      @ocuppied_seats = []
    end

    if $clicked_seats
      add_or_remove_clicked_seat
    else
      $clicked_seats = []
    end
  end

  def create
    mid, room, time, date = params[:movie_id], params[:room_id], (["Matiné", "Tanda", "Noche"].find_index(params[:time_id])+1), params[:date].to_date
    screening = Screening.where(movie_id: mid, room: room.to_i, time: time, date: date).first
    $clicked_seats.each do |seat|
      Seat.create(col: seat[:col], row: seat[:row], screening_id: screening.id)
    end
    $clicked_seats = []
    flash[:success] = 'Compra exitosa!'
    redirect_to view_seats_path(mid, room, time, date: date)
  end

  def receive_date
    mid, room, time, date = params[:movie_id], params[:room_id], params[:time_id], params[:date]
    $clicked_seats = []
    redirect_to view_seats_path(mid, room, time, date: date)
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
