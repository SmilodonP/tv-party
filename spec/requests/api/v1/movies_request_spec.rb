require 'rails_helper'

RSpec.describe "Movie Endpoints:", type: :request do
  describe "#index" do
    context "top rated movies" do
      it "retrieves the title and vote average of the top 20 movies", :vcr do
        get "/api/v1/movies/index"

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data]).not_to be(nil)        
        expect(json[:data].length).to eql(20)
        expect(json[:data][:attributes]).to have_key(:title)
        expect(json[:data][:attributes]).to have_key(:vote_average)
      end
    end

    context "movie search" do
      xit "retrieves movies based on a search query" do

      end
      xit "requires that the search term is passed as a query parameter" do

      end
      xit "retrieves a maximum of 20 results" do

      end
      xit "includes the title and the vote average of every movie"
    end
  end

  describe "#show" do
    context "movie details" do
      xit "returns the movie's details" do
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