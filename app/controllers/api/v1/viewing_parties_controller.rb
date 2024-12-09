class Api::V1::ViewingPartiesController < ApplicationController
  def create
    viewing_party = ViewingParty.new(party_params)
    if viewing_party.save
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def add_invitee
    viewing_party = ViewingParty.find_by(id: params[:viewing_party_id])
    invitee = User.find_by(id: params[:user_id])

    if viewing_party && invitee && !viewing_party.invitees.include?(invitee)
      viewing_party.invitees << invitee
      render json: ViewingPartySerializer.new(viewing_party), status: :ok
    else
      render json: { error: { message: "Unable to add invitee" } }, status: :bad_request
    end
  end

  private

  def party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id)
  end
end