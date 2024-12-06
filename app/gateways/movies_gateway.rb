class MoviesGateway
  BASE_URL = "https://api.themoviedb.org/3"

  class << self
    def get_top_20_movies
      endpoint = "/movie/popular"
      params = { language: "en-US", page: 1 }
      response = fetch_data(endpoint, params)
      response[:results].map { |movie_data| Movies.new(movie_data) }
    end

    def get_movie_details(movie_id)
      endpoint = "/movie/#{movie_id}"
      movie_data = fetch_data(endpoint)
      Movie.new(movie_data)
    end

    def movie_search(search_params)
      endpoint = "/search/movie"
      params = { query: search_params, adult: false, language: "en-US", page: 1 }
      response = fetch_data(endpoint, params)
      response[:results].map { |movie_data| Movies.new(movie_data) }
    end

    private

    def fetch_data(endpoint, params = {})
      puts "Requesting with params: #{params}"
      response = Faraday.get("#{BASE_URL}#{endpoint}", params) do |faraday|
        faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.themoviedb[:key]}"
      end

      if response.success?
        JSON.parse(response.body, symbolize_names: true)
      else
        raise "Failed to fetch data from #{endpoint}: #{response.status} #{response.body}"
      end
    end
  end
end