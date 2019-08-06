class Api::V1::MoviesController < ApplicationController
  def index
    @movies = Movie.all 
    render json: @movies
  end

  def show
    @movie = Movie.find(params[:id])
    @movie = {
      id: @movie.id,
      title: @movie.title
    }
    render json: @movie
  end

  def data_for_devs
    @movies = Movie.all
    @genre = Genre.all
    @result = []
    @genre.each do |genre|
      temp = { id: genre.id, attributes: { name: genre.name, count: Movie.where(genre_id: genre.id).count }}
      @result << temp
    end
    @data = {
      movies: @movies,
      genres: @result
    }
    render json: @data
  end
end