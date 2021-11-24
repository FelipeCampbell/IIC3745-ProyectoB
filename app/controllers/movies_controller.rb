require 'set'

class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @movies = Movie.all
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
    @movie.planners.build
    @movie.screenings.build
  end

  # POST /movies or /movies.json
  def create
    movie_params = movie_params()

    if !date_params?(movie_params)
      return render inline: "<p>You need to include start_date and end_date</p> <%= link_to 'New Movie', new_movie_path %>"
    end
    
    @movie = Movie.new(movie_params)
    rooms_are_free = check_planner()
    if(rooms_are_free)
      create_screenings()
    end
    invalid_fields = invalid_movie_fields?(movie_params)
    
    respond_to do |format|
      # veamos = movie_params
      if (rooms_are_free && !invalid_fields && @movie.save)
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        # format.html { render :new, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def date_params?(movie_params)
      not_start_date = movie_params["planners_attributes"]["0"]["start_date"].empty?
      not_end_date = movie_params["planners_attributes"]["0"]["end_date"].empty?
      if not_start_date || not_end_date
        return false
      end
      return true
    end

    def set_movie
      @movie = Movie.find(params[:id])
    end

    def check_planner()
      rooms_are_free = true
      # dates for planners that didnt receive (only first planner gets date from form)
      start_date = @movie.planners[0][:start_date]
      end_date = @movie.planners[0][:end_date]
      
      @movie.planners.each do |planner|
        planner[:start_date] = start_date
        planner[:end_date] = end_date
        @plannersOverlap = Planner.where('start_date < ? AND end_date > ? AND room = ? AND time = ?', planner.end_date, planner.start_date, planner.room, planner.time)
        @plannersOverlap.each do |plannerOverlap|
          Rails.logger.info "Topa con: ID: #{plannerOverlap.id}, StartDate: #{plannerOverlap.start_date}, EndDate: #{plannerOverlap.end_date}"
          @movie.errors.add(:base, "Schedule Overlap: Room #{plannerOverlap.room} at Time #{plannerOverlap.time} is used from #{plannerOverlap.start_date} to #{plannerOverlap.end_date}")
        end
        if(@plannersOverlap.length > 0)
          rooms_are_free = false
        end
      end
      return rooms_are_free
    end

    def invalid_movie_fields?(movie_params)
      errors = false
      if movie_params["name"].length > 100
        @movie.errors.add(:base, "Movie name is too long")
        errors = true
      end
      start_date = movie_params["planners_attributes"]["0"]["start_date"].to_date
      end_date = movie_params["planners_attributes"]["0"]["end_date"].to_date
      if start_date > end_date
        @movie.errors.add(:base, "start_date cannot be after end_date")
        errors = true
      end

      if duplicate_room_time?
        @movie.errors.add(:base, "room/time cannot be duplicated")
        errors = true
      end
      errors
    end

    def duplicate_room_time?
      roomtimes = Set.new
      for item in movie_params["planners_attributes"].to_hash.values do
        pair = [item["room"], item["time"]]
        if roomtimes.include?(pair)
          return true
        else
          roomtimes << pair
        end
      end
      return false
    end

    def create_screenings
      @screenings = []
      @movie.planners.each do |planner|
        room = planner[:room]
        time = planner[:time]
        (planner[:start_date] .. planner[:end_date]).each do |date|
          screening = Screening.new()
          screening.assign_attributes(:id => nil , :room => room, :time => time, :date => date, :movie_id => nil)
          @movie.screenings << screening
        end
      end
      Rails.logger.info "Screenings: #{@movie.screenings.inspect}"
    end
    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:name, :image, planners_attributes: [:id, :room, :start_date, :end_date, :time])
    end

end
