class MoviesGateway
  def self.get_top_20_movies(query_term)
    response = conn.get("/v1/IDONTKNOW", { query: query_term })

    json = JSON.parse(response.body, symbolize_names: true)
    Movies.new(json[:movies] [])
  end
end