class Movies
  attr_reader :id,
              :title,
              :vote_average

  def initialize(movies_data)
    @id = movies_data[:id]
    @title = movies_data[:title]
    @vote_average = movies_data[:vote_average]
  end
end