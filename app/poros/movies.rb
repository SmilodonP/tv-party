class Movies
  attr_reader :id,
              :title,
              :vote_average

  def initialize(data)
    @id = data[:id]
    @title = data[:attributes][:title]
    @vote_average = data[:attributes][:vote_average]
  end
end