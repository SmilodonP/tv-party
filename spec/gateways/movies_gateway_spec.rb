require 'rails_helper'

RSpec.describe MoviesGateway do
  describe "API calls:" do
    context "class methods" do
      it "gets the top 20 movies", :vcr do
        movies = MoviesGateway.get_top_20_movies

        expect(movies).to be_an(Array)
        expect(movies.size).to eq(20)
        expect(movies.first).to be_a(Movies)
        expect(movies.first.title).to be_a(String)
        expect(movies.first.vote_average).to be_a(Float)
      end

      it "gets details for a specific movie", :vcr do
        movie_id = 550
        movie = MoviesGateway.get_movie_details(movie_id)
        expect(movie).to be_a(Movie)
        expect(movie.title).to be_a(String)
        expect(movie.vote_average).to be_a(Float)
      end
    end
  end
end