class Api::V1::ViewingPartyController < ApplicationController
  def create
    viewing_party = ViewingParty.new(party_params)
    if viewing_party.save
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def update
    viewing_party = ViewingParty.find(party_params)
    if viewing_party.save
      render json: ViewingPartySerializer.new(viewing_party), status: :updated
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 400)), status: :bad_request
  end
end