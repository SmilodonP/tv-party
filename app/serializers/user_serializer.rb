class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :api_key

  def self.format_user_list(users)
    { 
      data: users.map do |user|
        {
          id: user.id.to_s,
          type: "user",
          attributes: {
            name: user.name,
            username: user.username
          }
        }
      end
    } 
  end

  def self.format_user(user)
    { data:
      {
        id: user.id.to_s,
        type: "user",
        attributes: {
          name: user.name,
          username: user.username,
          viewing_parties_hosted: viewing_parties.map do |viewing_party|
            {
              id: viewing_party.id,
              name: viewing_party.name,
              start_time: viewing_party.start_time,
              end_time: viewing_party.end_time,
              movie_id: viewing_party.movie_id,
              movie_title: viewing_party.movie_title,
              host_id: viewing_party.host_id
            }
          end,

          viewing_parties_invited: viewing_parties.map do |viewing_party|
            {
              id: viewing_party.id,
              name: viewing_party.name,
              start_time: viewing_party.start_time,
              end_time: viewing_party.end_time,
              movie_id: viewing_party.movie_id,
              movie_title: viewing_party.movie_title,
              host_id: viewing_party.host_id
            }
          end
        }
      }
    } 
  end
end