class MovieSerializer
  include JSONAPI::Serializer
  attributes :title, :release_year, :vote_average, :runtime, :genres, :summary, :cast, :total_reviews, :reviews

  def self.format_movie_list(movies)
    {
      data: movies.map do |movie|
        {
          id: movie.id.to_s,
          type: "movie",
          attributes: {
            title: movie.title,
            vote_average: movie.vote_average
          }
        }
      end
    }
  end

  def self.format_movie_details(movie)
    {
      data: {
        id: movie.id.to_s,
        type: "movie",
        attributes: {
          title: movie.title,
          release_year: movie.release_year,
          vote_average: movie.vote_average,
          runtime: movie.runtime,
          genres: movie.genres,
          summary: movie.summary,
          cast: movie.cast.map do |cast_member|
            {
              character: cast_member[:character],
              actor: cast_member[:actor]
            }
          end,
          total_reviews: movie.total_reviews,
          reviews: movie.reviews.map do |review|
            {
              author: review[:author],
              review: review[:review]
            }
          end
        }
      }
    }
  end
end