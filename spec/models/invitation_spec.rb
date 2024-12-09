require "rails_helper" 

RSpec.describe Invitation, type: :model do

  describe "relationships" do
    it {should belong_to(:user)}
    it {should belong_to(:viewing_party)}
  end

  describe "#rsvp_status" do
    it "defines the rsvp_status enum" do
      expect(Invitation.rsvp_statuses.keys).to match_array(%w[no maybe yes])
    end

    it "allows valid enum values" do
      andrew_wk = User.create!(name: "Andrew", username: "AndrewWK", password: "lets_party!", password_confirmation: "lets_party!")
      steve = User.create!(name: "Steve", username: "SteveTheDude", password: "my_name_is_Steve!", password_confirmation: "my_name_is_Steve!")
      bootsie = User.create!(name: "Bootsie", username: "MrBootsie", password: "my_name_is_bootsie!", password_confirmation: "my_name_is_bootsie!")

      party = ViewingParty.create!(name: "Party Hard!", start_time: Time.now, end_time: Time.now + 2.hours, movie_id: 1, movie_title: "Party Hard", host_id: andrew_wk.id)

      invitation = Invitation.create!(rsvp_status: 2, user_id: andrew_wk.id, viewing_party_id: party.id)
      invitation1 = Invitation.create!(rsvp_status: 0, user_id: steve.id, viewing_party_id: party.id)
      invitation2 = Invitation.create!(rsvp_status: 1, user_id: bootsie.id, viewing_party_id: party.id)

      expect(invitation).to be_valid
      expect(invitation.rsvp_status).to eq("yes")
      expect(invitation1.rsvp_status).to eq("no")
      expect(invitation2.rsvp_status).to eq("maybe")
    end

    it "raises error for invalid enum values" do
      expect { Invitation.create!(rsvp_status: :invalid_status) }.to raise_error(ArgumentError)
    end
  end
end