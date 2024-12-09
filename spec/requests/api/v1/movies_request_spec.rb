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
        movie = JSON.parse(response.body, symbolize_names: true)
        expect(movie[:data]).not_to be(nil) 

        expect(movie[:data]).to have_key(:attributes)
        expect(movie[:data][:attributes]).to have_key(:title)
        expect(movie[:data][:attributes]).to have_key(:release_year)
        expect(movie[:data][:attributes]).to have_key(:vote_average)
        expect(movie[:data][:attributes]).to have_key(:runtime)
        expect(movie[:data][:attributes]).to have_key(:genres)
        expect(movie[:data][:attributes]).to have_key(:summary)
        expect(movie[:data][:attributes]).to have_key(:cast)
        expect(movie[:data][:attributes]).to have_key(:reviews)
      end

      it "raises error for bad request", :vcr do
        get "/api/v1/movies/0"
        expect(response).not_to be_successful
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:error]).to eq("Failed to fetch movie details, please check movie id and try again")
      end
    end
  end
end