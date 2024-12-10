require 'rails_helper'

RSpec.describe "Movie Search" do
  describe "search #index" do
    context "movie search" do
      it "gets 20 searched for movies" do
        get "/api/v1/movies/search", params: { query: "Toxic" }
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

      it "can return less than 20 movies" do
        get "/api/v1/movies/search", params: { query: "The Toxic Avenger" }
        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data]).not_to be(nil)  
        expect(json[:data]).to be_an(Array)
        expect(json[:data].length).to eql(8)

        json[:data].each do |movie|
          expect(movie).to have_key(:attributes)
          expect(movie[:attributes]).to have_key(:title)
          expect(movie[:attributes]).to have_key(:vote_average)
        end
      end
    end
  end

  describe "Sad Path" do
    context "when no query parameter is provided" do
      it "returns a bad request error" do
        get "/api/v1/movies/search"
        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:error]).to eq("Failed to search for movies")
        expect(json[:details]).not_to be_empty
      end
    end
  
    context "when the query parameter is empty" do
      it "returns a bad request error" do
        get "/api/v1/movies/search", params: { query: "" }
        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:error]).to eq("Failed to search for movies")
        expect(json[:details]).not_to be_empty
      end
    end
  
    context "when no results are found for the query" do
      it "returns an empty data array" do
        get "/api/v1/movies/search", params: { query: "Nonexistent Movie Query" }
        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:data]).to eq([])
      end
    end
  end
end
