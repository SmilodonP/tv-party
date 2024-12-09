require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  before(:each) do
    @host = User.create!(name: "Ed", username: "A_Horse", password:"Glue", password_confirmation: "Glue")
    @invitee1 = User.create!(name: "Steve", username: "A_Priest", password: "Je$u$", password_confirmation: "Je$u$")
    @invitee2 = User.create!(name: "Ronnie", username: "A_Rabbi", password: "Mo$e$", password_confirmation: "Mo$e$")
    @party = ViewingParty.create!(
              name: "Walk into a bar",
              host: @host, 
              start_time: Time.now, 
              end_time: Time.now + 2.hours,
              movie_id: 300, 
              movie_title: "Comedy Ensues")
    @invitaiton1 = Invitation.create!(user: @invitee1, viewing_party: @party)
    @invitaiton2 = Invitation.create!(user: @invitee2, viewing_party: @party)
  end
  
  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:start_time)}
    it {should validate_presence_of(:end_time)}
    it {should validate_numericality_of(:movie_id).only_integer}
    it {should validate_presence_of(:movie_title)}

    it "validates that end_time is after start_time" do
      viewing_party = ViewingParty.new(
        name: "Test Party Party",
        start_time: Time.now,
        end_time: Time.now - 1.hour,
        movie_id: 1,
        movie_title: "Moo-Vee",
        host: @host
      )
      expect(viewing_party).not_to be_valid
      expect(viewing_party.errors).to include("Parties must begin before they end!")
    end
  end
    
  describe "relationships" do
    it {should have_many :invitations}
    it {should have_many(:invitees).class_name('User').through(:invitations)}
    it {should belong_to(:host).class_name('User').with_foreign_key('host_id')}

    it "returns party's invitees" do
      expect(@party.invitees).to contain_exactly(@invitee1, @invitee2)
    end
  end
end