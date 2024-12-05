class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :viewing_party
  
  enum rsvp_status: { no: 0, maybe: 1, yes: 2 }
end