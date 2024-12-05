require 'rails_helper'

RSpec.describe Movies, type: :poro do
  describe '#initialize' do
    let(:movies_data) do
      {
        id: 666,
        title: 'Shaun of the Dead',
        vote_average: 9.5
      }
    end

    subject { Movies.new(movies_data) }

    it 'initializes with the correct id' do
      expect(subject.id).to eq(666)
    end

    it 'initializes with the correct title' do
      expect(subject.title).to eq('Shaun of the Dead')
    end

    it 'initializes with the correct vote_average' do
      expect(subject.vote_average).to eq(9.5)
    end
  end
end