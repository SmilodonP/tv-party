class Movie
  attr_reader :id, :title, :release_year, :vote_average, :runtime, :genres, :summary, :cast, :total_reviews, :reviews

  def initialize(data)
    @id = data[:id]
    @title = data[:title]
    @release_year = extract_year(data[:release_date])
    @vote_average = data[:vote_average]
    @runtime = format_runtime(data[:runtime])
    @genres = data[:genres]&.map { |genre| genre[:name] } || []
    @summary = data[:overview]
    @cast = format_cast(data.dig(:credits, :cast))
    @total_reviews = data.dig(:reviews, :results)&.size || 0
    @reviews = format_reviews(data.dig(:reviews, :results))
  end

private

  def extract_year(release_date)
    release_date&.split('-')&.first
  end

  def format_runtime(minutes)
    return nil unless minutes
    hours = minutes / 60
    mins = minutes % 60
    "#{hours} hours, #{mins} minutes"
  end

  def format_cast(cast_data)
    return [] unless cast_data
    cast_data[0..9].map do |member|
      {
        character: member[:character],
        actor: member[:name]
      }
    end
  end

  def format_reviews(review_data)
    return [] unless review_data
    review_data[0..4].map do |review|
      {
        author: review[:author],
        review: review[:content]
      }
    end
  end
end
