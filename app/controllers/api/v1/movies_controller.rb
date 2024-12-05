class Api::V1::MoviesController < ApplicationController
  def index
    begin
      movies = MoviesGateway.get_top_20_movies
      render json: MovieSerializer.format_movie_list(movies)
    rescue => e
      render json: { error: "Failed to fetch movies", details: e.message }, status: :bad_request
    end
  end

  def show
    begin 
      movie = MoviesGateway.get_movie_details(find_by(params[:id])
      render json: MovieSerializer.format_movie_details(movie)
    rescue => e
      render json: { error: "Failed to fetch movie details" }, status: :bad_request
    end
  end
end
