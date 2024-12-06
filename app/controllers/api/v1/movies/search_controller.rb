class Api::V1::Movies::SearchController < ApplicationController
  def index
    Rails.logger.info "Request received at /api/v1/movies/search"
    binding.pry
    begin
      search_params = params[:query].to_s
      puts "Searching for: #{search_params}"
      movies = MoviesGateway.movie_search(search_params)
      render json: MovieSerializer.format_movie_list(movies)
    rescue => e
      render json: { error: "Failed to search for movies", details: e.message }, status: :bad_request
    end
  end
end