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
    @movie = Movie.new(movie_params)
    rooms_are_free = check_planner()
    if(rooms_are_free)
      create_screenings()
    end
    # Rails.logger.info "Que onda 0: #{@movie.planners} "
    # Rails.logger.info "Veamos las movies planners 0: #{@movie.inspect} "

    
    respond_to do |format|
      # veamos = movie_params
      if (rooms_are_free && @movie.save)
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
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def check_planner()
      rooms_are_free = true
      # dates for planners that didnt receive (only first planner gets date from form)
      start_date = @movie.planners[0][:start_date]
      end_date = @movie.planners[0][:end_date]
      
      #Rails.logger.info "Lets check for overlap"
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
