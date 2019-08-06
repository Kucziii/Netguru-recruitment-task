class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    loop_through_movies
    puts @result
  end

  def show
    get_movie_data
    @movie = Movie.find(params[:id])
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailer.send_info(current_user, @movie).deliver_now
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporter.new.call(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end

  private

  def get_movie_data
    movie_title = URI.encode(Movie.find(params[:id]).title)
    link = "https://pairguru-api.herokuapp.com/api/v1/movies/" + movie_title
    response = HTTParty.get(link)
    @data = JSON.parse(response.body)
    img = @data["data"]["attributes"]["poster"]
    @img_link = "https://pairguru-api.herokuapp.com#{img}"
  end

  def loop_through_movies
    movies = Movie.all.decorate
    @movies_data = []

    movies.each do |movie|
      movie_title = URI.encode(movie.title)
      link = "https://pairguru-api.herokuapp.com/api/v1/movies/" + movie_title
      response = HTTParty.get(link)
      @data = JSON.parse(response.body)
      img = @data["data"]["attributes"]["poster"]
      temp = {
        id: movie.id,
        title: movie.title,
        desc: movie.description,
        released: movie.released_at,
        genre: movie.genre,
        genre_name: movie.genre.name,
        plot: @data["data"]["attributes"]["plot"],
        img_link: "https://pairguru-api.herokuapp.com#{img}",
        rating: @data["data"]["attributes"]["rating"]
      }
      @movies_data << temp
    end
  end
end
