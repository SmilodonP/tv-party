class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def index
    users= User.all
    render json: UserSerializer.format_user_list(User.all)
  end

  def show
    user = User.find_by(id: params[:user_id])
    if user
      hosted_parties = ViewingParty.where(host_id: user.id).map do |party|
        {
          id: party.id,
          name: party.name,
          start_time: party.start_time,
          end_time: party.end_time,
          movie_id: party.movie_id,
          movie_title: party.movie_title,
          host_id: party.host_id
        }
      end
      invited_parties = ViewingParty.joins(:invitations)
                                    .where(invitations: {user_id: user.id})
                                    .map do |party|
        {
          name: party.name,
          start_time: party.start_time,
          end_time: party.end_time,
          movie_id: party.movie_id,
          movie_title: party.movie_title,
          host_id: party.host_id
        }
      end
    render json: {
        data: {
          id: user.id.to_s,
          type: "user",
          attributes: {
            name: user.name,
            username: user.username,
            viewing_parties_hosted: hosted_parties,
            viewing_parties_invited: invited_parties
          }
        }
      }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def user_params
    params.permit(:name, :username, :password, :password_confirmation)
  end
end