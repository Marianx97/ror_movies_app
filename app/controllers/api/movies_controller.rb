class Api::MoviesController < Api::ApiController
  before_action :set_movie, only: %i[show update destroy]
  before_action :authorize_request, only: %i[create update destroy]
  before_action :authorize_admin!, only: %i[create update destroy]

  def index
    @movies = Movie.where(deleted_at: nil).order(created_at: :desc)
    render json: @movies
  end

  def show
    render json: @movie
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      render json: @movie, status: :created
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.update(deleted_at: Time.current)
    head :no_content
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :description, :director, :producer, :release_date)
  end
end
