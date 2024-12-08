require 'bcrypt'

class User < ApplicationRecord
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key

  has_many :invitations
  has_many :viewing_parties, through: :invitations
  has_many :hosted_parties, class_name: 'ViewingParty', foreign_key: 'host_id'

end