require 'rails_helper'

RSpec.describe "Movie Endpoints:", type: :request do
  describe "#index" do
    context "top rated movies" do
      it "retrieves the title and vote average of the top 20 movies", :vcr do
        get "/api/v1/movies"
        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data]).not_to be(nil)  
        expect(json[:data]).to be_an(Array)
        expect(json[:data].length).to eql(20)

        json[:data].each do |movie|
          expect(movie).to have_key(:attributes)
          expect(movie[:attributes]).to have_key(:title)
          expect(movie[:attributes]).to have_key(:vote_average)
        end
      end
    end
  end

  describe "#show" do
    context "movie details" do
      it "returns the movie's details", :vcr do
        get "/api/v1/movies/122"
        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data]).not_to be(nil)  
        # Title
        # Release year
        # Vote average
        # Runtime in hours & minutes
        # Genre(s) associated to movie
        # Summary description
        # List the first 10 cast members (characters & actors)
        # Count the total reviews
        # List of first 5 reviews (author and review)
      end
      xit "includes the movie's api id in the path" do

      end
    end
  end
end