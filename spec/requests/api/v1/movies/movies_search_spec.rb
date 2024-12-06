require 'rails_helper'

RSpec.describe "Movie Search" do
  context "movie search" do
    it "gets 20 searched for movies" do
      get "/api/v1/movies/search", params: { query: "Toxic" }
      puts response.body
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
