class ViewingParty < ApplicationRecord
  validates :name, presence: true, length: { maximum: 99 }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time
  validates :movie_id, presence: true, numericality: { only_integer: true }
  validates :movie_title, presence: true
  validate :valid_invitees

private

  def end_time_after_start_time
    if start_time.present? && end_time.present? && end_time <= start_time
      errors.add("Parties must begin before they end!")
    end
  end

  # def enough_party_time
  #   if (end_time - start_time) < movie([:attributes][:runtime])
  #     errors.add("Not Enough Party Time!")
  #   end
  # end

  def valid_invitees
    if invitees.blank? || !invitees.is_a?(Array)
      errors.add(:invitees, "must be an array of user IDs")
    elsif invitees.any? { |id| !User.exists?(id) }
      errors.add(:invitees, "contains invalid user IDs")
    end
  end

end