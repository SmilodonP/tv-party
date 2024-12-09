class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :host, :start_time, :end_time, :movie_id, :movie_title, :invitees 

  attribute :invitees do |object|
    object.invitees.map do |invitee|
      {
        id: invitee.id,
        name: invitee.name,
        username: invitee.username
      }
    end
  end
end
