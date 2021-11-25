class WelcomeController < ApplicationController

  def index 
    if $clicked_seats
      add_or_remove_clicked_seat
    else
      $clicked_seats = []
    end
  end

  def add_or_remove_clicked_seat
    if params[:row] and params[:column]
      clicked_seat = {row:params[:row], column:params[:column].to_i}
      if $clicked_seats.include?(clicked_seat)
        $clicked_seats.delete(clicked_seat)
      else
        $clicked_seats << clicked_seat
      end
    end
  end

end
