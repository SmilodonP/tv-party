require 'rails_helper'

RSpec.describe "Viewing Party Endpoints:", type: :request do

  before(:each) do
    @host = User.create!(
            name: "Henry",
            username: "BlackFlag",
            password: "LiftingWeightsNStuff",
            password_confirmation: "LiftingWeightsNStuff"
            )

    @valid_params = {
              name: "TV Party Tonight",
              start_time: 1.hour.from_now,
              end_time: 3.hours.from_now,
              movie_id: 1,
              movie_title: "Not A Real Movie",
              host_id: @host.id
              }

    @invalid_params = {
                name: nil,
                start_time: nil,
                end_time: nil,
                movie_id: nil,
                movie_title: nil,
                host_id: nil
              }

    @party = ViewingParty.create!(@valid_params)
    @invitee1 = User.create!(name: "Greg", username: "GregGinn", password: "Punk4Life" , password_confirmation: "Punk4Life")
    @invitee2 = User.create!(name: "Chuck", username: "Dukowski", password: "Wurm" , password_confirmation: "Wurm")
  end

  describe "#create" do
    context "with valid parameters" do
      it "creates a new viewing party" do
        party_count = ViewingParty.count

        post "/api/v1/viewing_parties", params: {viewing_party: @valid_params}
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes][:name]).to eq("TV Party Tonight")
        expect(json[:data][:attributes][:movie_title]).to eq("Not A Real Movie")

        expect(ViewingParty.count).to eq(party_count + 1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new viewing party" do
        party_count = ViewingParty.count

        post "/api/v1/viewing_parties", params: {viewing_party: @invalid_params}
        expect(response).to have_http_status(:bad_request)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq( "Name can't be blank, Start time can't be blank, End time can't be blank, Movie can't be blank, Movie is not a number, Movie title can't be blank, and Host must exist")

        expect(ViewingParty.count).to eq(party_count)
      end
    end
  end

  describe "#add_invitee" do
    context "with a valid user ID" do
      it "adds the user to the viewing party's invitees" do
        post "/api/v1/viewing_parties/#{@party.id}/invitees", params: { user_id: @invitee1.id }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        
        invitee_ids = json[:data][:attributes][:invitees].map { |invitee| invitee[:id] }

        expect(invitee_ids).to include(@invitee1.id)
        expect(invitee_ids).to_not include(@invitee2.id)
      end
    end

    context "with an invalid user ID" do
      it "returns a bad request error" do
        post "/api/v1/viewing_parties/#{@party.id}/invitees", params: { user_id: nil }

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:error][:message]).to eq("Unable to add invitee")
      end
    end
  end
end