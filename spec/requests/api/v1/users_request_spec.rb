require "rails_helper"

RSpec.describe "Users Requests", type: :request do
  describe "Create User Endpoint" do
    let(:user_params) do
      {
        name: "Me",
        username: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end

    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_users_path, params: user_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:username]).to eq(user_params[:username])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique username" do
        User.create!(name: "me", username: "its_me", password: "abc123")

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        user_params = {
          name: "me",
          username: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        user_params[:username] = ""

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end

  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      User.create!(name: "Tom", username: "mr_myspace", password: "test123")
      User.create!(name: "Oprah", username: "oprah", password: "abcqwerty")
      User.create!(name: "Beyonce", username: "mrs_jayz", password: "blueivy")

      get api_v1_users_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(9)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:username)
      expect(json[:data][0][:attributes]).to_not have_key(:password)
      expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
      expect(json[:data][0][:attributes]).to_not have_key(:api_key)
    end
  end

  describe "User #show" do
    before(:each) do
      @user = User.create!(name: "Leo DiCaprio", username: "leo_real_verified", password: "password")
      @user1 = User.create!(name: "Dude", username: "The_Dude", password: "password")
      @user2 = User.create!(name: "Guy", username: "Some_Guy", password: "password")
      
      @hosted_party = ViewingParty.create!(
        name: "Titanic Watch Party",
        start_time: "2025-05-01 10:00:00",
        end_time: "2025-05-01 14:30:00",
        movie_id: 597,
        movie_title: "Titanic",
        host_id: @user.id
      )

      @invited_party1 = ViewingParty.create!(
        name: "LOTR Viewing Party",
        start_time: "2025-03-11 10:00:00",
        end_time: "2025-03-11 15:30:00",
        movie_id: 120,
        movie_title: "The Lord of the Rings: The Fellowship of the Ring",
        host_id: @user1.id
      )

      @invited_party2 = ViewingParty.create!(
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        host_id: @user1.id
      )

      @invited_party3 = ViewingParty.create!(
        name: "Let's watch clueless together!",
        start_time: "2025-01-15 10:00:00",
        end_time: "2025-01-15 14:30:00",
        movie_id: 9603,
        movie_title: "Clueless",
        host_id: @user2.id
      )

      Invitation.create!(user_id: @user.id, viewing_party_id: @invited_party1.id)
      Invitation.create!(user_id: @user.id, viewing_party_id: @invited_party2.id)
      Invitation.create!(user_id: @user.id, viewing_party_id: @invited_party3.id)
    end

    context "when the user exists" do
      it "returns the user with hosted and invited viewing parties" do
        get "/api/v1/users/#{@user.id}"
        binding.pry

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:id]).to eq(@user.id.to_s)
        expect(json[:data][:type]).to eq("user")

        attributes = json[:data][:attributes]
        expect(attributes[:name]).to eq(@user.name)
        expect(attributes[:username]).to eq(@user.username)

        expect(attributes[:viewing_parties_hosted].length).to eq(1)
        hosted_party = attributes[:viewing_parties_hosted].first
        expect(hosted_party[:id]).to eq(@hosted_party.id)
        expect(hosted_party[:name]).to eq(@hosted_party.name)
        expect(hosted_party[:movie_id]).to eq(@hosted_party.movie_id)
        expect(hosted_party[:movie_title]).to eq(@hosted_party.movie_title)
        expect(hosted_party[:host_id]).to eq(@hosted_party.host_id)

        expect(attributes[:viewing_parties_invited].length).to eq(3)
        invited_party_names = attributes[:viewing_parties_invited].map { |party| party[:name] }
        expect(invited_party_names).to include("LOTR Viewing Party", "Juliet's Bday Movie Bash!", "Let's watch clueless together!")
      end
    end

    context "when the user does not exist" do
      it "returns a 404 error" do
        get "/api/v1/users/99999"

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:error]).to eq("User not found")
      end
    end
  end
end
