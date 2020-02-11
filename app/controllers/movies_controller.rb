class MoviesController < ApplicationController
  before_action :set_movie, only: [:destroy, :show]

  def index
    @q = Movie.ransack(params[:q])
    @movies = @q.result.page params[:page]
  end

  def show
  end

  def new
    @movie = Movie.new
  end
  
  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to root_path, notice: 'Filme criado!'
    else
      render :new
    end
  end
  
  def destroy
    if @movie.destroy
      redirect_to root_path, notice: 'Filme excluído!'
    else
      render :index
    end
  end
  
  private
  
  def movie_params
    params.require(:movie).permit(:id, :name, :description, :release, :image, :clip)
  end
  
  def set_movie
    @movie = Movie.find(params[:id])
  end
end
