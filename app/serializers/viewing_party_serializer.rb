class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :host, :start_time, :end_time,:movie_id :movie_title, :invitees 

  def self.format_party(party)
    {
      data: {
        id: party.id.to_s,
        type: viewing_party,
        attributes: {
          name: party.name,
          host: party.user.name
          start_time: party.start_time,
          end_time: party.end_time,
          movie_id: party.id,
          movie_title: party.title,
          invitees: party.invitees do |user|
            {
              id: user.id,
              name: user.name,
              username: user.username
            }          
          end
        }
      }
    }
  end

  private

end