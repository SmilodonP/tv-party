class Api::V1::MoviesController < ApplicationController
  def index
    movies = 
  end

  private

  conn = Faraday.new(url: "https://api.themoviedb.org/3/") do |faraday|
    faraday.headers["Authorization"] = Rails.application.credentials.themoviedb[:key]
  end
end