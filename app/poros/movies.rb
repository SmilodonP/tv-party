class Movies
  attr_reader :id,
              :title,
              :release_year,
              :vote_average,
              :runtime,
              :genres,
              :summary,
              :cast,
              :total_reviews,
              :reviews

  def initialize(data)
    @id = data[:id]
    @title = data[:attributes][:title]
    @release_year = data[:attributes][:release_year]
    @vote_average = data[:attributes][:vote_average]
    @runtime = data[:attributes][:runtime]
    @genres = data[:attributes][:genres]
    @summary = data[:attributes][:summary]
    @cast = data[:attributes][:cast].map { |member| CastMember.new(member) } if data[:attributes][:cast]
    @total_reviews = data[:attributes][:total_reviews]
    @reviews = data[:attributes][:reviews].map { |review| Review.new(review) } if data[:attributes][:reviews]
  end

  class CastMember
    attr_reader :character, :actor

    def initialize(data)
      @character = data[:character]
      @actor = data[:actor]
    end
  end

  class Review
    attr_reader :author, :review

    def initialize(data)
      @author = data[:author]
      @review = data[:review]
    end
  end
end
