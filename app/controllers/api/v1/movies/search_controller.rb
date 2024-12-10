class Api::V1::Movies::SearchController < ApplicationController
  def index
    search_params = params[:query].to_s.strip
    if search_params.blank?
      render json: { error: "Failed to search for movies", details: "Query parameter is missing or empty" }, status: :bad_request
      return
    end

    begin
      movies = MoviesGateway.movie_search(search_params)
      render json: MovieSerializer.format_movie_list(movies)
    rescue => e
      render json: { error: "Failed to search for movies", details: e.message }, status: :bad_request
    end
  end
end
