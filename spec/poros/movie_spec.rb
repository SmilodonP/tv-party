require 'rails_helper'

RSpec.describe Movie, type: :poro do
  let(:movie_data) do
    {
      id: 2,
      title: "Hot Fuzz",
      release_date: "2007-02-14",
      vote_average: 7.8,
      runtime: 121,
      genres: [{ name: "Action" }, { name: "Comedy" }, { name: "Crime" }],
      overview: "A skilled London cop is transferred to a small town with a dark secret.",
      credits: { cast: [{ character: "Nicholas Angel", name: "Simon Pegg" }, { character: "Danny Butterman", name: "Nick Frost" }] },
      reviews: { results: [{ author: "Reviewer 1", content: "Very funny!" }, { author: "Reviewer 2", content: "Action-packed and hilarious!" }] }
    }
  end

  describe "#initialize" do
    it "correctly initializes all attributes" do
      movie = Movie.new(movie_data)

      expect(movie.id).to eq(2)
      expect(movie.title).to eq("Hot Fuzz")
      expect(movie.release_year).to eq("2007")
      expect(movie.vote_average).to eq(7.8)
      expect(movie.runtime).to eq("2 hours, 1 minutes")
      expect(movie.genres).to eq(["Action", "Comedy", "Crime"])
      expect(movie.summary).to eq("A skilled London cop is transferred to a small town with a dark secret.")
      expect(movie.cast).to eq([{ character: "Nicholas Angel", actor: "Simon Pegg" }, { character: "Danny Butterman", actor: "Nick Frost" }])
      expect(movie.total_reviews).to eq(2)
      expect(movie.reviews).to eq([{ author: "Reviewer 1", review: "Very funny!" }, { author: "Reviewer 2", review: "Action-packed and hilarious!" }])
    end
  end

  describe "#extract_year" do
    it "returns the correct year from release_date for Hot Fuzz" do
      movie = Movie.new(movie_data)
      expect(movie.send(:extract_year, movie_data[:release_date])).to eq("2007")
    end

    it "returns nil if release_date is nil" do
      movie_data[:release_date] = nil
      movie = Movie.new(movie_data)
      expect(movie.send(:extract_year, movie_data[:release_date])).to be_nil
    end
  end

  describe "#format_runtime" do
    it "formats the runtime correctly for Hot Fuzz" do
      movie = Movie.new(movie_data)
      expect(movie.send(:format_runtime, movie_data[:runtime])).to eq("2 hours, 1 minutes")
    end

    it "returns nil if runtime is nil" do
      movie_data[:runtime] = nil
      movie = Movie.new(movie_data)
      expect(movie.send(:format_runtime, movie_data[:runtime])).to be_nil
    end
  end

  describe "#format_cast" do
    it "correctly formats the cast" do
      movie = Movie.new(movie_data)
      expect(movie.send(:format_cast, movie_data[:credits][:cast])).to eq([
        { character: "Nicholas Angel", actor: "Simon Pegg" },
        { character: "Danny Butterman", actor: "Nick Frost" }
      ])
    end

    it "returns an empty array if cast_data is nil" do
      movie_data[:credits][:cast] = nil
      movie = Movie.new(movie_data)
      expect(movie.send(:format_cast, nil)).to eq([])
    end

    it "limits the cast to a maximum of 10" do
      cast_list = movie_data[:credits][:cast] + [
        { character: "Extra 1", name: "Actor 1" },
        { character: "Extra 2", name: "Actor 2" },
        { character: "Extra 3", name: "Actor 3" },
        { character: "Extra 4", name: "Actor 4" },
        { character: "Extra 5", name: "Actor 5" },
        { character: "Extra 6", name: "Actor 6" },
        { character: "Extra 7", name: "Actor 7" },
        { character: "Extra 8", name: "Actor 8" },
        { character: "Extra 9", name: "Actor 9" },
        { character: "Extra 10", name: "Actor 10" },
        { character: "Extra 11", name: "Actor 11" }
      ]
      movie_data[:credits][:cast] = cast_list
      movie = Movie.new(movie_data)

      expect(movie.send(:format_cast, cast_list).size).to eq(10)
    end
  end

  describe "#format_reviews" do
    it "correctly formats reviews" do
      movie = Movie.new(movie_data)
      expect(movie.send(:format_reviews, movie_data[:reviews][:results])).to eq([
        { author: "Reviewer 1", review: "Very funny!" },
        { author: "Reviewer 2", review: "Action-packed and hilarious!" }
      ])
    end

    it "returns an empty array if review_data is nil" do
      movie_data[:reviews][:results] = nil
      movie = Movie.new(movie_data)
      expect(movie.send(:format_reviews, nil)).to eq([])
    end

    it "limits the reviews to a maximum of 5" do
      reviews_list = movie_data[:reviews][:results] + [
        { author: "Reviewer 3", content: "This" },
        { author: "Reviewer 4", content: "Is" },
        { author: "Reviewer 5", content: "A" },
        { author: "Reviewer 6", content: "Test." }
      ]
      movie_data[:reviews][:results] = reviews_list
      movie = Movie.new(movie_data)

      expect(movie.send(:format_reviews, reviews_list).size).to eq(5)
    end
  end
end
